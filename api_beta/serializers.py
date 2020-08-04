from decimal import Decimal
from django.utils import timezone
from moneyed import Money
from moneyed.localization import format_money
from rest_framework import serializers
from rest_framework.reverse import reverse
import json
import random

from cards.cardset import Cardset
from language import Translation, LANGUAGE_CHOICES, LANGUAGE_DEBUG, pick_language
from reports.serializers import ReportSerializer
from tools.utils import full_url

class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField(max_length=255)
    password = serializers.CharField(max_length=255)

class AccountSerializer(serializers.Serializer):
    def to_representation(self, account):
        response = {
            'id': str(account.id),
            'name': account.name,
            'anonymous': account.anonymous,
        }

        return response

class PlayerSerializer(serializers.Serializer):
    def to_representation(self, account):
        response = {
            'id': str(account.id),
            'name': account.name,
            'anonymous': account.anonymous,
        }

        if not account.anonymous:
            response['email'] = account.email

        return response

class MeSerializer(serializers.Serializer):
    def to_representation(self, request):
        response = {
            'language': pick_language(request),
            'language_choices': LANGUAGE_CHOICES,
        }
        if request.user.is_authenticated:
            account = request.user.account

            response.update({
                'id': str(account.id),
                'email': account.email,
                'name': account.name,
                'logged_in': True,
                'email_confirmed': account.email_confirmed,
                'available_games': account.total_games_available(),
                'anonymous': account.anonymous,
                'is_admin': account.admin,
                'group_codes': account.group_code_override,
                'admin_reports': account.admin_report_override,
                'report_branding': account.report_branding,
                'site_branding': account.site_branding,
            })
            # NOTICE: This is where we renew/validate subscriptions
            subscription = account.get_subscription()
            if subscription:
                response['subscription'] = SubscriptionSerializer(subscription).data
                response['group_codes'] = subscription.group_codes or response['group_codes']
                response['admin_reports'] = subscription.admin_reports or response['admin_reports']
                
        else:
            response['logged_in'] = False

        return response

class ChangeMeSerializer(serializers.Serializer):
    email = serializers.EmailField(max_length=255, allow_blank=True, required=False)
    old_password = serializers.CharField(max_length=255, allow_blank=True, required=False)
    password = serializers.CharField(max_length=255, allow_blank=True, required=False)
    password_change_token = serializers.UUIDField(allow_null=True, required=False)
    name = serializers.CharField(max_length=64, allow_blank=True, required=False)
    language = serializers.ChoiceField(choices=tuple(LANGUAGE_CHOICES + LANGUAGE_DEBUG), required=False)

class CreateMeSerializer(serializers .Serializer):
    email = serializers.EmailField(max_length=255)
    password = serializers.CharField(max_length=255)
    name = serializers.CharField(max_length=30, allow_blank=True, required=False)
    language = serializers.ChoiceField(choices=tuple(LANGUAGE_CHOICES + LANGUAGE_DEBUG), required=False)

class AvailableGamesSerializer(serializers.Serializer):
    def to_representation(self, available_game):
        return {
            'cardset': CardsetShareSerializer(available_game.cardset).data,
            'count': available_game.count,
        }

class CardsetSerializer(serializers.Serializer):
    def to_representation(self, cardset):
        cardset = Cardset.get_cardset(cardset)

        return {
            'id': cardset.cardset['id'],
            'name': cardset.cardset['strings']['name'],
        }

class CardsetShareSerializer(serializers.Serializer):
    def to_representation(self, cardset):
        data = cardset.data()

        return {
            'id': str(cardset.id),
            'name': data.name,
            'description': data.description,
        }

class CardsetVersionDetailSerializer(serializers.Serializer):
    def to_representation(self, game):
        cardset = Cardset.get_cardset(game.cardset)

        response = {
            'id': cardset.cardset['id'],
            'language': game.language,
            'name': cardset.cardset['strings']['name'],
            'categories': CardCategorySerializer(cardset.categories_list, many=True).data,
            'cards': CardSerializer(cardset.cards_list, many=True).data,
        }

        response = self.translate(response, game.language)

        return response

    def translate(self, response, language):
        t = Translation(language)
        for i in range(len(response['categories'])):
            response['categories'][i]['name'] = t.gettext(response['categories'][i]['name'])
            response['categories'][i]['description'] = t.gettext(response['categories'][i]['description'])
        for i in range(len(response['cards'])):
            response['cards'][i]['text'] = t.gettext(response['cards'][i]['text'])

        return response

class CardsetPriceSerializer(serializers.Serializer):
    def to_representation(self, cardset_price):
        return {
            'min_qty': cardset_price.min_qty,
            'unit_price': {
                'amount': cardset_price.unit_price.amount,
                'amount_display': format_money(cardset_price.unit_price, locale='en_US'),
                'currency': cardset_price.unit_price_currency,
                'currency_display': cardset_price.get_unit_price_currency_display(),
            }
        }

class CardCategorySerializer(serializers.Serializer):
    def to_representation(self, category):
        return {
            'id': category['id'],
            'name': category['strings']['name'],
            'description': category['strings']['description'],
        }

class CardSerializer(serializers.Serializer):
    def to_representation(self, card):
        return {
            'id': card['id'],
            'text': card['strings']['text'],
            'category': card['category'],
        }

class StripePlanSerializer(serializers.Serializer):
    def to_representation(self, plan):
        group_codes = False
        if plan['metadata'].get('group_codes', 'false') == 'true':
            group_codes = True

        admin_reports = False
        if plan['metadata'].get('admin_reports', 'false') == 'true':
            admin_reports = True

        return {
            'id': plan['id'],
            'amount': plan['amount'],
            'price': format_money(Money(Decimal(plan['amount'])/Decimal(100), plan['currency']), locale='en_US'),
            'name': plan['name'],
            'games': plan['metadata'].get('games', ''),
            'description': plan['metadata'].get('description', ''),
            'group_codes': group_codes,
            'admin_reports': admin_reports,
        }

class StripeProductSerializer(serializers.Serializer):

    def to_representation(self, product):
        return {
            'id': product['id'],
            'amount': product['skus']['data'][0]['price'],
            'price': format_money(Money(Decimal(product['skus']['data'][0]['price'])/Decimal(100), product['skus']['data'][0]['currency']), locale='en_US'),
            'name': product['name'],
            'games': product['metadata'].get('games', ''),
            'description': product['metadata'].get('description', ''),
        }

class GameSerializer(serializers.Serializer):
    def to_representation(self, game):
        response = {
            'id': str(game.id),
            'created_date': game.created_date,
            'modified_date': game.modified_date,
            'cardset_name': game.cardset,
            'owner': AccountSerializer(game.owner).data,
            'player': PlayerSerializer(game.player).data,
            'share': ShareInGameSummarySerializer(game.share).data,
            'last_activity_date': game.last_activity_date,
            'completed': game.completed,
            'pdf_url': game.pdf_url(),
            'professional_url': game.professional_url(),
        }

        if game.completed:
            response['results'] = game.data['categories']

        if game.owner.hide_player_reports:
            response['hide_player_reports'] = True
            response['player_report_alt_message'] = game.owner.player_report_alt_message

        return response


class GameDetailSerializer(serializers.Serializer):
    def to_representation(self, game):
        response = {
            'id': str(game.id),
            'created_date': game.created_date,
            'modified_date': game.modified_date,
            'cardset_name': game.cardset,
            'owner': AccountSerializer(game.owner).data,
            'player': AccountSerializer(game.player).data,
            'share': ShareInGameSummarySerializer(game.share).data,
            'last_activity_date': game.last_activity_date,
            'completed': game.completed,
            'pdf_url': game.pdf_url(),
            'professional_url': game.professional_url(),
        }

        if game.completed:
            response['results'] = game.data['categories']
            #response['report'] = ReportSerializer(game).data
        else:
            response['answers'] = game.data['answers']
            response['cards'] = game.data['cards']
            response['cardset_data'] = CardsetVersionDetailSerializer(game).data

        if game.owner.hide_player_reports:
            response['hide_player_reports'] = True
            response['player_report_alt_message'] = game.owner.player_report_alt_message

        return response

class SubscriptionSerializer(serializers.Serializer):
    def to_representation(self, subscription):
        return {
            'id': str(subscription.id),
            'created_date': subscription.created_date,
            'modified_date': subscription.modified_date,
            'active': subscription.active,
            'active_until': subscription.active_until,
            'plan_id': subscription.stripe_plan_id,
            'plan_name': subscription.stripe_plan_name,
            'manual': subscription.manual_override,
        }

class SubscriptionChangeInputSerializer(serializers.Serializer):
    plan_id = serializers.CharField()

class ShareSerializer(serializers.Serializer):
    def to_representation(self, data):
        response = {
            'owner': AccountSerializer(data['share'].owner).data,
            'cardset': 'adult',
            'code': data['share'].code,
            'name': data['share'].name,
            'available': data['share'].used < data['share'].total or not data['share'].owner.enforce_limits,
            'created_date': data['share'].created_date,
            'anonymous': data['share'].is_anonymous(),
            'claimed': data['share'].games.filter(player=data['player']).exists(),
            'individual': data['share'].individual,
            'player_pays': data['share'].owner.player_pays,
        }

        if data['share'].owner.site_branding and hasattr(data['share'].owner, 'branding'):
            response['branding'] = BrandingSerializer(data['share'].owner.branding).data

        if response['claimed']:
            response['game_id'] = str(data['share'].games.filter(player=data['player']).first().id)

        return response

class ShareInGameSummarySerializer(serializers.Serializer):
    def to_representation(self, share):
        return {
            'owner': AccountSerializer(share.owner).data,
            'code': share.code,
            'name': share.name,
            'available': share.used < share.total,
            'created_date': share.created_date,
            'anonymous': share.is_anonymous(),
            'individual': share.individual,
        }

class ShareDetailSerializer(serializers.Serializer):
    def to_representation(self, share):
        return {
            'owner': AccountSerializer(share.owner).data,
            'cardset': 'adult',
            'code': share.code,
            'name': share.name,
            'used': share.used,
            'total': share.total,
            'available': share.used < share.total,
            'created_date': share.created_date,
            'anonymous': share.is_anonymous(),
            'individual': share.individual,
        }

class ShareInputSerializer(serializers.Serializer):
    cardset_id = serializers.CharField(required=False)
    quantity = serializers.IntegerField(min_value=1)
    name = serializers.CharField(required=False, allow_blank=True, default='')
    emails = serializers.ListField(child=serializers.EmailField(allow_blank=True), default=None, allow_null=True)

class ShareAnonymousClaimInputSerializer(serializers.Serializer):
    name = serializers.CharField(required=False, default="Anonymous User")

class AnswerInputSerializer(serializers.Serializer):
    card_id = serializers.CharField()
    answer = serializers.IntegerField()

class AnswerSerializer(serializers.Serializer):
    def to_representation(self, answer):
        return str(answer.card.id)

class BrandingSerializer(serializers.Serializer):
    def to_representation(self, branding):
        return {
            'cover_text': branding.load_cover_text(),
            'cover_image_url': '/' + branding.cover_image_url() + '?{}'.format(branding.modified_date.microsecond),
        }
