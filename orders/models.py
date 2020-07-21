from dateutil.relativedelta import relativedelta
from django.conf import settings
from django.db import models
from django.utils import timezone
from djmoney.models.fields import MoneyField
from moneyed import Money
import json
import moneyed
import stripe
import uuid

stripe.api_key = settings.STRIPE_SECRET_KEY

class Subscription(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    created_date = models.DateTimeField(auto_now_add=True)
    modified_date = models.DateTimeField(auto_now=True)

    account = models.ForeignKey('accounts.Account', on_delete=models.CASCADE, related_name='subscriptions')
    active = models.BooleanField(default=True)
    active_until = models.DateTimeField()
    stripe_subscription_id = models.CharField(max_length=64)
    stripe_plan_id = models.CharField(max_length=255)
    stripe_plan_name = models.CharField(max_length=255)
    group_codes = models.BooleanField(default=False)
    admin_reports = models.BooleanField(default=False)
    manual_override = models.BooleanField(default=False)
    interval = models.CharField(max_length=255)
    games = models.IntegerField()

    def validate_subscription(self):
        if self.active_until > timezone.now():
            return
        else:
            self.refresh_subscription()

    def refresh_subscription(self, force=False):
        if self.manual_override:
            subscription_data = self.manual_subscription_data
        else:
            subscription_data = stripe.Subscription.retrieve(self.stripe_subscription_id)

        stripe_active_until = timezone.datetime.fromtimestamp(subscription_data['current_period_end'], tz=timezone.utc)

        if stripe_active_until < timezone.now():
            self.unused_games.all().delete()
            self.delete()

        if self.active_until < stripe_active_until or force:
            self.active_until = stripe_active_until
            games = subscription_data['plan']['metadata']['games']
            self.games = games
            self.account.renew_games(self, games)
            self.stripe_plan_name = subscription_data['plan']['name']

        self.save()

        return self

    def change_subscription(self, plan_id):
        subscription = stripe.Subscription.retrieve(self.stripe_subscription_id)

        previous_games = subscription['plan']['metadata']['games']
        subscription.plan = plan_id
        subscription.save()
        new_games = subscription['plan']['metadata']['games']

        self.account.add_games_to_subscription(int(new_games) - int(previous_games), self)

        self.stripe_plan_id = subscription['plan']['id']
        self.stripe_plan_name = subscription['plan']['name']
        self.interval= subscription['plan']['interval']
        self.games = int(subscription['plan']['metadata']['games'])
        if subscription['plan']['metadata']['group_codes'] == 'false':
            self.group_codes = False
        else:
            self.group_codes = True
        if subscription['plan']['metadata']['admin_reports'] == 'false':
            self.admin_reports = False
        else:
            self.admin_reports = True

        self.save()

        return self

    def unsubscribe(self):
        subscription = stripe.Subscription.retrieve(self.stripe_subscription_id)
        subscription.delete(at_period_end=True)
        self.active = False
        self.save()

        return self

    def manual_subscription_data(self):
        return {
            'application_fee_percent': None,
            'billing': 'charge_automatically',
            'cancel_at_period_end': false,
            'canceled_at': None,
            'created': int(self.created_date.strftime('%s')),
            'current_period_end': int((self.active_until + relativedelta(months=1)).strftime('%s')),
            'current_period_start': int(self.active_until.strftime('%s')),
            'customer': self.account.email,
            'discount': None,
            'ended_at': None,
            'id': str(self.id),
            'items': {
                'data': [
                    {
                        'created': int(self.created_date.strftime('%s')),
                        'id': str(self.id),
                        'metadata': {},
                        'plan': {
                            'amount': 0,
                            'created': int(self.created_date.strftime('%s')),
                            'currency': 'usd',
                            'id': str(self.id),
                            'interval': self.interval,
                            'interval_count': 1,
                            'livemode': False,
                            'metadta': {
                                'admin_reports': self.admin_reports,
                                'games': self.games,
                                'group_codes': self.group_codes,
                            },
                            'name': self.stripe_plan_name,
                            'object': 'plan',
                            'statement_descriptor': '',
                            'trial_period_days': None
                        },
                        'quantity': 1,
                    }
                ],
                'has_more': False,
                'object': 'list',
                'total_count': 1,
                'url': None
            },
            'livemode': False,
            'metadata': {},
            'object': 'subscription',
            'plan': {
                'amount': 0,
                'created': int(self.created_date.strftime('%s')),
                'currency': 'usd',
                'id': int(self.created_date.strftime('%s')),
                'interval': 'month',
                'interval_count': 1,
                'livemode': False,
                'metadata': {
                    'admin_reports': self.admin_reports,
                    'games': self.games,
                    'group_codes': self.group_codes,
                },
                'name': self.stripe_plan_name,
                'object': 'plan',
                'statement_descriptor': '',
                'trial_period_days': None
            },
            'quantity': 1,
            'start': int(self.created_date.strftime('%s')),
            'status': 'active',
            'tax_percent': None,
            'trial_end': None,
            'trial_start': None,
        }

    @classmethod
    def create_subscription(Subscription, account, plan_id):
        s = account.get_subscription()
        if s and not s.active:
            s.delete();
        elif s and s.active:
            return None

        customer = stripe.Customer.retrieve(account.stripe_customer_id)
        stripe_subscription = stripe.Subscription.create(
            customer = account.stripe_customer_id,
            plan = plan_id,
        )

        plan = stripe.Plan.retrieve(plan_id)
        if plan['metadata']['group_codes'] == 'false':
            group_codes = False
        else:
            group_codes = True
        if plan['metadata']['admin_reports'] == 'false':
            admin_reports = False
        else:
            admin_reports = True

        subscription = Subscription.objects.create(
            account = account,
            active_until = timezone.datetime.fromtimestamp(stripe_subscription['current_period_end'], tz=timezone.utc),
            stripe_subscription_id = stripe_subscription['id'],
            stripe_plan_id = stripe_subscription['plan']['id'],
            stripe_plan_name = stripe_subscription['plan']['name'],
            group_codes = group_codes,
            admin_reports = admin_reports,
            interval = stripe_subscription['plan']['interval'],
            games = int(stripe_subscription['plan']['metadata']['games']),
        )

        subscription.refresh_subscription(True)

        return subscription

class Order(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    created_date = models.DateTimeField(auto_now_add=True)
    modified_date = models.DateTimeField(auto_now=True)

    account = models.ForeignKey('accounts.Account', on_delete=models.CASCADE, related_name='orders')
    active = models.BooleanField(default=True)
    active_until = models.DateTimeField()
    stripe_product_id = models.CharField(max_length=255)
    stripe_product_name = models.CharField(max_length=255)

    @classmethod
    def create_order(Order, account, product_id):
        product = stripe.Product.retrieve(product_id)
        customer = stripe.Customer.retrieve(account.stripe_customer_id)

        stripe.Charge.create(
            customer = customer.id,
            amount = product['skus']['data'][0]['price'],
            currency = 'usd',
            description = product.name,
        )

        if 'games' in product.metadata:
            account.add_games(product.metadata['games'])
