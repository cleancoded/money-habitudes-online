from django.conf import settings
from django.contrib.auth.models import User
from django.core.validators import validate_email
from django.db import models
from urllib.parse import urlparse

import base64
import json
import os
import random
import stripe
import uuid

from accounts.helpers import format_image

stripe.api_key = settings.STRIPE_SECRET_KEY

class Account(models.Model):
    def report_end_upload_path(instance, filename):
        return '{0}/branding/report_end.pdf'.format(instance.id)

    id = models.UUIDField(primary_key=True, default=uuid.uuid4)
    created_date = models.DateTimeField(auto_now_add=True)
    modified_date = models.DateTimeField(auto_now=True)

    user = models.OneToOneField(User, on_delete=models.SET_NULL, blank=True, null=True)
    name = models.CharField(max_length=64)
    email = models.CharField(max_length=255)
    email_confirmed = models.BooleanField(default=False)
    anonymous = models.BooleanField(default=False)
    stripe_customer_id = models.CharField(max_length=64, blank=True)
    enforce_limits = models.BooleanField(default=True)
    group_code_override = models.BooleanField(default=False)
    admin_report_override = models.BooleanField(default=False)
    report_branding = models.BooleanField(default=False)
    site_branding = models.BooleanField(default=False)
    player_pays = models.BooleanField(default=False)
    anonymous_games = models.BooleanField(default=False)
    show_next_steps = models.BooleanField(default=True)
    report_end = models.FileField(upload_to=report_end_upload_path, blank=True)
    hide_player_reports = models.BooleanField(default=False)
    player_report_alt_message = models.TextField(default='')
    admin = models.BooleanField(default=False)
    language = models.CharField(max_length = 5, default='')
    extra_languages = models.BooleanField(default=False)

    def __unicode__(self):
        return self.email

    def report_end_url(self):
        if self.report_end:
            return 'static/media/{0}/branding/report_end.pdf'.format(self.id)
        else:
            return ''

    def get_subscription(self):
        try:
            s = self.subscriptions.first()
            s.validate_subscription()
            return s
        except:
            return None

    def get_email_confirm_code(self):
        return uuid.uuid5(uuid.NAMESPACE_OID, ':{}:{}:{}:{}:'.format(self.id.hex, self.user.id, self.email, self.created_date.isoformat()))

    def get_password_reset_code(self):
        return uuid.uuid5(uuid.NAMESPACE_OID, ':{}:{}:{}:{}:{}:'.format(self.id.hex, self.user.id, self.email, self.user.password, self.created_date.isoformat()))

    def confirm_email(self, confirmation_code):
        if uuid.UUID(confirmation_code) == self.get_email_confirm_code():
            self.email_confirmed = True
            self.save()

            if self.stripe_customer_id:
                customer = stripe.Customer.retrieve(self.stripe_customer_id)
                customer.email = self.email
                customer.save()

            return True
        else:
            return False

    def set_email(self, email):
        email = email.lower()

        if self.email == email:
            return

        validate_email(email)
        if self.user:
            self.user.username = email
            self.user.email = email
            self.user.save()

        self.email = email
        self.email_confirmed = False
        self.save()

    def set_name(self, name):
        name = Account.get_name(self.email, name)
        self.name = name
        self.save()

        self.user.save()

        for game in self.played_games.all():
            game.player_name = self.name
            game.save()

    def set_password(self, password):
        self.user.set_password(password)
        self.user.save()

    def enable_site_branding(self):
        self.site_branding = True
        self.save()
        if hasattr(self, 'branding'):
            for share in self.shares.all():
                share.branding = self.branding
                share.save()

    # Adds games (for individual purchases)
    def add_games_to_subscription(self, count, subscription=''):
        # If games are added to an account, they are an admin
        self.admin = True
        self.save()

        count = int(count)

        try:
            obj = self.available_games.get(subscription=subscription)
            new_count = obj.count + count
            if new_count <= 0:
                obj.delete()
            else:
                obj.count = new_count
                obj.save()
        except:
            if count > 0:
                if subscription:
                    self.available_games.create(subscription=subscription, count=count)
                else:
                    self.add_games(count)

    def add_games(self, count):
        count = int(count)
        # If games are added to an account, they are an admin
        if count > 1:
            self.admin = True
            self.save()

        try:
            obj = self.available_games.get(subscription__isnull=True)
            new_count = obj.count + count
            if new_count <= 0:
                obj.delete()
            else:
                obj.count = new_count
                obj.save()
        except:
            if count > 0:
                self.available_games.create(count=count)

    def get_bonus_games_count(self):
        try:
            games = self.available_games.get(subscription__isnull=True)
            return games.count
        except:
            return 0

    def set_bonus_games_count(self, count):
        curCount = self.get_bonus_games_count()
        self.add_games(count - curCount)

    def use_games(self, count):
        if self.total_games_available() >= count:
            regular_games = self.available_games.filter(subscription__isnull=True).first()
            if regular_games:
                if regular_games.count > count:
                    regular_games.count -= count
                    regular_games.save()
                    return
                else:
                    count -= regular_games.count
                    regular_games.delete()

            subscription_games = self.available_games.exclude(subscription__isnull=True)
            for subscription_game in subscription_games:
                if subscription_game.count > count:
                    subscription_game.count -= count
                    subscription_game.save()
                    return
                else:
                    count -= subscription_game.count
                    subscription_game.delete()

    def total_games_available(self):
        if self.player_pays:
            return 10000

        total = 0
        for available in self.available_games.all():
            total += available.count

        return total

    def usage_stats(self):
        used = 0
        total = 0
        for share in self.shares.all():
            used += share.used
            total += share.total
        total += self.total_games_available()

        return (used, total)

    # If the user has more than one game, we label them admins
    def is_admin(self):
        total_games = 0
        total_games += self.owned_games.count()
        if total_games > 1:
            return True

        total_games += self.total_games_available()
        if total_games > 1:
            return True

        for share in self.shares.all():
            total_games += share.total
            if total_games > 1:
                return True

        return False

    # Renews subscription (for subscriptions)
    def renew_games(self, subscription, count):
        self.admin = True
        self.save()

        try:
            available_games = self.available_games.filter(subscription=subscription)
            if available_games.count() > 1:
                keeper = available_games.first()
                available_games.exclude(id=keeper.id).delete()
                available_games = keeper
            if available_games.count > count:
                return
            else:
                available_games.count = count
                available_games.save()
        except:
            self.available_games.create(subscription=subscription, count=count)

    def create_share(self, cardset_id, count, name='', individual=True):
        """
        Create a new share code.

        :cardset_id: String id of cardset used.
        :count: Number of games to assign to code.
        :name: Name of share.
        :individual: Is this an individual code.
        """
        available_games = self.total_games_available()

        if available_games < count:
            return None

        code = None
        while not code or Share.objects.filter(code=code).exists():
            code = Account.generate_code()

        if not name:
            name = code

        share = self.shares.create(
            cardset = cardset_id,
            code = code,
            name = name,
            total = count,
            individual = individual,
        )

        self.use_games(count)

        return share

    # Functions
    def delete_user(self):
        if self.user:
            self.user.delete()

        if self.stripe_customer_id:
            customer = stripe.Customer.retrieve(self.stripe_customer_id)
            customer.delete()
            self.stripe_customer_id = ''
            self.save()

    @classmethod
    def create_account(Account, email, password, name='', language='', anonymous=False):
        email = email.lower()
        validate_email(email)
        name = Account.get_name(email, name)

        user = User.objects.create_user(
            username = email,
            email = email,
            password = password,
            )

        try:
            account = Account.objects.create(
                user = user,
                email = email,
                name = name,
                language=language,
                anonymous = anonymous,
            )
        except:
            user.delete()
            raise

        return account

    @classmethod
    def create_anonymous_account(Account, name='Anonymous User', language='en_US'):
        email = '{}@localhost'.format(uuid.uuid4().hex)
        return Account.create_account(email, uuid.uuid4().hex, name, language=language, anonymous=True)

    # Helpers
    def get_name(email, name):
        if name:
            name = name
        elif email.split('@')[1] == 'localhost':
            name = ''
        else:
            name = email.split('@')[0]

        return name

    def generate_code():
        return ''.join(random.choice('ABCDEFGHJKLMNPQRSTUVWXYZ23456789') for i in range(8))

    def get_capabilities(self):
        capabilities = {
            'group_codes': self.group_code_override,
            'admin_reports': self.admin_report_override,
            'report_branding': self.report_branding,
            'site_branding': self.site_branding,
            'subscription': None
        }

        subscription = self.get_subscription()
        if subscription:
            capabilities['group_codes'] = capabilities['group_codes'] or subscription.group_codes
            capabilities['admin_reports'] = capabilities['admin_reports'] or subscription.admin_reports
            capabilities['subscription'] = {
                'active_until': subscription.active_until,
                'stripe_plan_id': subscription.stripe_plan_id,
                'interval': subscription.interval,
                'active': subscription.active,
            }

        return capabilities

class AvailableGames(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    created_date = models.DateTimeField(auto_now_add=True)
    modified_date = models.DateTimeField(auto_now=True)

    account = models.ForeignKey(Account, on_delete=models.CASCADE, related_name='available_games')
    subscription = models.ForeignKey('orders.Subscription', on_delete=models.CASCADE, related_name='unused_games', blank=True, null=True)
    count = models.PositiveIntegerField(default=0)

class Branding(models.Model):
    def cover_image_upload_path(instance, filename):
        return '{0}/branding/cover_image.png'.format(instance.account.id)

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    created_date = models.DateTimeField(auto_now_add=True)
    modified_date = models.DateTimeField(auto_now=True)

    account = models.OneToOneField(Account, on_delete=models.CASCADE, related_name='branding')
    cover_text = models.TextField(default='{}')
    cover_image = models.ImageField(upload_to=cover_image_upload_path, blank=True)

    def save(self, *args, **kwargs):
        if self.cover_image:
            image = format_image(self.cover_image, 600, 200)

            temp_name = self.cover_image.name
            self.cover_image.delete(save=False)

            self.cover_image.save(
                temp_name,
                content=image,
                save=False
            )

        self.cover_text = json.dumps(self.cover_text.splitlines()[0:5])


        super(Branding, self).save(*args, **kwargs)

    def load_cover_text(self):
        return json.loads(self.cover_text)

    def cover_image_url(self):
        if self.cover_image:
            return 'static/media/{0}/branding/cover_image.png'.format(self.account.id)
        else:
            return ''

    def full_delete(self):
        if self.cover_image and os.path.isfile(self.cover_image.path):
            os.remove(self.cover_image.path)
        self.delete()

class Share(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    created_date = models.DateTimeField(auto_now_add=True)
    modified_date = models.DateTimeField(auto_now=True)

    owner = models.ForeignKey(Account, on_delete=models.CASCADE, related_name='shares')
    cardset = models.CharField(max_length=16)
    code = models.CharField(max_length=16, unique=True, db_index=True)
    name = models.CharField(max_length=64)
    total = models.PositiveIntegerField()
    used = models.PositiveIntegerField(default=0)
    anonymous = models.BooleanField(default=False)
    enforce_referrer = models.BooleanField(default=False)
    referrer_urls = models.TextField(default='[]')
    individual = models.BooleanField(default=True)

    def is_anonymous(self):
        if self.anonymous == True:
            return True
        elif self.owner.anonymous_games == True:
            return True
        else:
            return False

    def claimed(self, account):
        if account.played_games.filter(share=self).exists():
            return True
        else:
            return False

    def recover(self, qty):
        if self.total - self.used - qty < 0 and self.owner.enforce_limits:
            raise

        self.total -= qty
        self.save()

        self.owner.add_games(qty)

        if self.total == 0:
            self.delete()
            return None

        return self

    def change_qty(self, qty):
        if qty < self.used or qty < 0 or qty - self.total > self.owner.total_games_available():
            raise

        if qty < self.total:
            self.owner.add_games(self.total - qty)

        if qty > self.total:
            self.owner.use_games(qty - self.total)

        self.total = qty
        self.save()

        if self.total == 0:
            self.delete()
            return None
        return self


    def is_valid_referrer(self, request):
        return True
        if self.enforce_referrer:
            urls = json.loads(self.referrer_urls)
            referrer = request.META.get('HTTP_REFERER', '')
            #parsed_url = urlparse(request.META.get('HTTP_REFERER', ''))
            #stripped_url = '{}{}'.format(parsed_url.netloc, parsed_url.path)
            for url in urls:
                if url in referrer:
                    return True
                else:
                    return False

        return True

    def get_referrer_list(self):
        return json.loads(self.referrer_urls)

    def store_referrer_list(self, list):
        self.referrer_urls = json.dumps(list)
        self.save()

    def total_games_available(self):
        if self.player_pays:
            return 10000

        total = 0
        for available in self.available_games.all():
            total += available.count

        return total
