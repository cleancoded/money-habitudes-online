from django.conf import settings
from django.contrib.auth import authenticate, login, logout
from django.db.models import Q
from django.http import Http404, HttpResponseRedirect
from django.views.decorators.csrf import csrf_exempt
from rest_framework import permissions, status
from rest_framework.decorators import api_view
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.response import Response
from rest_framework.reverse import reverse
from rest_framework.settings import api_settings
from rest_framework.views import APIView
import datetime
import json
import stripe
import uuid

from accounts.models import Account, Share, Branding
from api_beta import pagination, serializers
from cards.cardset import Cardset
from orders.models import Subscription, Order
from games.models import Game
from language import pick_language, Translation
from tools.utils import full_url, send_mail

stripe.api_key = settings.STRIPE_SECRET_KEY

class ApiRoot(APIView):
    """
    All available API endpoints are listed here.
    """
    def get(self, request):
        return Response([
            full_url(request, reverse('login')),
            full_url(request, reverse('logout')),
            full_url(request, reverse('me')),
            full_url(request, reverse('products')),
            full_url(request, reverse('games')),
            full_url(request, reverse('orders')),
            full_url(request, reverse('shares')),
        ])

class Login(APIView):
    """
    Login for session auth. Use a POST request containing email and password fields.\n
    Example: `{"email": "someone@example.com", "password": "12345"}`
    """
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        credentials = serializers.LoginSerializer(data=request.data)

        if not credentials.is_valid():
            return Response(status=status.HTTP_400_BAD_REQUEST)

        user = authenticate(
            username = credentials.data['email'].lower(),
            password = credentials.data['password'],
        )

        if not user:
            return Response(status=status.HTTP_401_UNAUTHORIZED)

        login(request, user)
        serializer = serializers.MeSerializer(request)

        return Response(serializer.data)

class Logout(APIView):
    """
    Logout for session auth. Use an empty POST request.
    """
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request):
        logout(request)
        serializer = serializers.MeSerializer(request)

        return Response(serializer.data)

class Me(APIView):
    """
    When logged in, this API provides basic user information.\n
    When logged out, this API indicates you are logged out.
    """
    permission_classes = (permissions.AllowAny,)

    def get(self, request):
        serializer = serializers.MeSerializer(request)
        return Response(serializer.data)

    def post(self, request):
        user = serializers.CreateMeSerializer(data=request.data)

        if not user.is_valid():
            return Response(status=status.HTTP_400_BAD_REQUEST)

        try:
            account = Account.create_account(
                user.data['email'],
                user.data['password'],
                name=user.data.get('name', ''),
                language=user.data.get('language', 'en_US'),
            )
        except:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        login(request, account.user)

        me = serializers.MeSerializer(request)

        #send_mail(
        #    request,
        #    account.email,
        #    'Welcome to Money Habitudes {}!'.format(account.name),
        #    'welcome',
        #    {
        #        'confirm_url': full_url(request, '/#/email/{}'.format(account.get_email_confirm_code()))
        #    },
        #)

        return Response(me.data)


    def put(self, request):
        if not request.user.is_authenticated:
            return Response(status=status.HTTP_401_UNAUTHORIZED)

        changes = serializers.ChangeMeSerializer(data=request.data)

        if not changes.is_valid():
            return Response(status=status.HTTP_400_BAD_REQUEST)

        account = request.user.account

        if 'email' in changes.data and changes.data['email'] != account.email:
            account.set_email(changes.data['email'])

#            send_mail(
#                request,
#                account.email,
#                'Please confirm your email address'.format(account.name),
#                'confirm',
#                {
#                    'confirm_url': full_url(request, '/#/email/{}'.format(account.get_email_confirm_code()))
#                },
#            )
        if 'name' in changes.data:
            account.set_name(changes.data['name'])

        if 'language' in changes.data:
            account.language = changes.data['language']
            account.save()

        me = serializers.MeSerializer(request)
        return Response(me.data)

    def delete(self, request):
        if not request.user.is_authenticated:
            return Response(status=status.HTTP_401_UNAUTHORIZED)

        account = request.user.account
        logout(request)
        account.delete_user()

        return Response(status=status.HTTP_202_ACCEPTED)

class ChangePassword(APIView):
    """
    POST 'current_password' and 'password' to change known password.
    POST 'email' and 'password_reset_token' and 'password' to change unknown password
    POST 'email' and 'forgot: true' to send forgot password email
    """
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        if 'password' in request.data:
            if 'current_password' in request.data:
                try:
                    account = request.user.account
                except:
                    return Response(status=status.HTTP_401_UNAUTHORIZED)
                if account.anonymous or authenticate(username = account.email, password = request.data['current_password']):
                    account.set_password(request.data['password'])
                    account.anonymous = False
                    account.save()
                    return Response(status=status.HTTP_202_ACCEPTED)
                else:
                    return Response(status=status.HTTP_401_UNAUTHORIZED)
            elif 'email' in request.data and 'password_reset_token' in request.data:
                account = Account.objects.get(email=request.data['email'])
                if uuid.UUID(request.data['password_reset_token']) == account.get_password_reset_code():
                    account.set_password(request.data['password'])
                    return Response(status=status.HTTP_202_ACCEPTED)
                else:
                    return Response(status=status.HTTP_401_UNAUTHORIZED)
        elif 'forgot' in request.data and 'email' in request.data:
            try:
                account = Account.objects.get(email=request.data['email'])
            except Account.DoesNotExist:
                return Response(status=status.HTTP_404_NOT_FOUND)
            send_mail(
                request,
                account.email,
                'Your password change request',
                'changepassword',
                {
                    'password_url': full_url(request, '/#/password/?email={}&token={}'.format(account.email, account.get_password_reset_code()))
                }
            )
            return Response(status=status.HTTP_202_ACCEPTED)

        return Response(status=status.HTTP_400_BAD_REQUEST)

class MeSendConfirm(APIView):
    """
    Re-send confirmation email with an empty POST request
    """
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request):
        account = request.user.account

        send_mail(
            request,
            account.email,
            'Please confirm your email address'.format(account.name),
            'confirm',
            {
                'confirm_url': full_url(request, '/#/email/{}'.format(account.get_email_confirm_code()))
            },
        )

        return Response(status=status.HTTP_202_ACCEPTED)

class MeConfirm(APIView):
    """
    Confirm your email address with an empty POST request.
    """
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request, pk):
        if request.user.account.confirm_email(pk):
            return Response(status=status.HTTP_202_ACCEPTED)
        else:
            return Response(status=status.HTTP_406_NOT_ACCEPTABLE)

class Products(APIView):
    """
    Displays all active products and their prices.\n
    You may also view a specific product by providing its ID in the URL path.
    The pricing information comes from Stripe.
    """
    permission_classes = (permissions.AllowAny,)

    def get(self, request):
        plans = stripe.Plan.list(limit=100)
        planset = []
        for plan in plans:
            try:
                plan['metadata']['games']
                plan['metadata']['group_codes']
                plan['metadata']['admin_reports']
                planset.append(plan)
            except:
                pass
        planset.sort(key=lambda x: x['amount'])
        plan_serializer = serializers.StripePlanSerializer(planset, many=True)

        products = stripe.Product.list()
        productset = []
        for product in products:
            if product['metadata'].get('hidden', '').lower() != 'true':
                productset.append(product)
        productset.sort(key=lambda x: x['skus']['data'][0]['price'])
        product_serializer = serializers.StripeProductSerializer(productset, many=True)

        return Response({
            'plans': plan_serializer.data,
            'products': product_serializer.data,
        })

class ProductDetail(APIView):
    """
    Displays data about an individual cardset.
    """
    permission_classes = (permissions.AllowAny,)

    def get(self, request, pk):
        cardset = Cardset.objects.get(pk=pk)
        serializer = serializers.CardsetDetailSerializer(cardset)
        return Response(serializer.data)

class Games(APIView):
    """
    List of games the user has permissions to see.
    """
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request):
        account = request.user.account
        games = Game.objects.filter(Q(owner=account) | Q(player=account))

        sort = request.GET.get('order_by', '-last_activity_date')
        games = games.order_by(sort)

        filter = request.GET.get('filter_by', '')
        if filter:
            games = games.filter(Q(player_name__icontains=filter) | Q(share_name__icontains=filter) | Q(player_email__icontains=filter))

        paginator = pagination.MhPagination()
        game_page = paginator.paginate_queryset(games, request)

        serializer = serializers.GameSerializer(game_page, many=True)

        return paginator.get_paginated_response(serializer.data)

    @api_view(['GET'])
    def last_played(request):
        try:
            account = request.user.account
            game = account.played_games.latest('modified_date')
        except:
            return Response(status=status.HTTP_204_NO_CONTENT)

        serializer = serializers.GameSerializer(game)
        return Response(serializer.data)

class GameDetail(APIView):
    """
    GET all game data, used to play the game.\n
    PUT for functions reserved for owners\n
    POST an answer to a card.\n
    DELETE to undo the last answer.
    """
    permission_classes = (permissions.AllowAny,)

    def get(self, request, pk):
        game = Game.objects.get(pk=pk)
        if game.completed == False:
            game.finalize() # Finalizes if game is finished, otherwise does nothing
            game.language = pick_language(request)
        serializer = serializers.GameDetailSerializer(game)
        return Response(serializer.data)

    def post(self, request, pk):
        answer_data = serializers.AnswerInputSerializer(data=request.data)

        if not answer_data.is_valid():
            return Response(status=status.HTTP_400_BAD_REQUEST)

        account = request.user.account
        game = account.played_games.get(pk=pk)

        game.answer(answer_data.data['answer'])

        if game.completed and not game.owner.hide_player_reports:
            send_mail(
                request,
                game.player.email,
                '{} - your Money Habitudes Online report'.format(game.player.name),
                'game_completed',
                {
                    'player': game.player,
                    'report_url': full_url(request, '#/load?path={}'.format(game.pdf_url())),
                },
            )

        return Response(status=status.HTTP_202_ACCEPTED)

    def put(self, request, pk):
        game = request.user.account.owned_games.get(pk=pk)

        if request.data.get('remind', False) and not game.completed:
            send_mail(
                request,
                game.player.email,
                '{} reminded you to complete your Money Habitudes game'.format(request.user.account.name),
                'reminder',
                {
                    'host_url': full_url(request),
                    'share_url': full_url(request, '#/codes/{}'.format(game.share.code)),
                    'share_code': game.share.code,
                },
            )
            return Response(status=status.HTTP_202_ACCEPTED)

        if request.data.get('revoke', False) and not game.completed:
            if game.share.individual:
                game.share.used = 0
                game.share.save()
                game.share.change_qty(0)
            else:
                game.share.used -= 1
                game.share.save()
                game.delete()
            return Response(status=status.HTTP_202_ACCEPTED)

        return Response(status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        account = request.user.account
        game = account.played_games.get(pk=pk)
        card = game.undo()

        return Response(status=status.HTTP_202_ACCEPTED)

class Orders(APIView):
    """
    POST to order individual games.
    """
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request):
        try:
            account = request.user.account
            order_id = request.data['order_id']
            order_token = request.data['token']['id']
            site_branding = request.data.get('site_branding', False)
            report_branding = request.data.get('report_branding', False)

            if account.stripe_customer_id:
                customer = stripe.Customer.retrieve(account.stripe_customer_id)
                card = customer.sources.create(source=order_token)
                customer.default_source = card.id
                customer.save()
            else:
                customer = stripe.Customer.create(
                    email = request.user.account.email,
                    card = order_token
                )
                account.stripe_customer_id = customer['id']
                account.save()

            if order_id == 'mh_individual' or order_id == 'mh_ptp' or order_id == 'mh_ptp_10':
                Order.create_order(account, order_id)
            elif order_id == 'branding_only':
                pass
            elif order_id == 'cc_change':
                pass
            else:
                subscription = Subscription.create_subscription(account, order_id)
                try:
                    send_mail(
                        request,
                        account.email,
                        'Thanks for subscribing to Money Habitudes Online {}'.format(account.name),
                        'subscribe',
                        {
                            'subscription_name': subscription.stripe_plan_name,
                            'host_url': full_url(request),
                        },
                    )
                except:
                    pass

            if site_branding:
                Order.create_order(account, 'site_branding')
                account.enable_site_branding()
            if report_branding:
                Order.create_order(account, 'report_branding')
                account.report_branding = True
                account.save()

            return Response(status=status.HTTP_202_ACCEPTED)

        except Exception as e:
            raise e
            return Response(status=status.HTTP_400_BAD_REQUEST)

class Subscriptions(APIView):
    """
    GET to get subscription list, POST to create a subscription.
    """
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request):
        subscriptions = request.user.account.subscriptions.order_by('modified_date')

        serializer = serializers.SubscriptionSerializer(subscriptions, many=True)

        return Response(serializer.data)

    def post(self, request):
        subscription = Subscription.create_subscription(request.user.account, request.POST)

        if request.POST.get('redirect', False):
            return HttpResponseRedirect('/#/dashboard?subscription=true')

        return Response({'success': True})

class SubscriptionPaymentInfo(APIView):
    """"
    POST to update payment info for subscriptions
    """
    def post(self, request):
        customer = stripe.Customer.retrieve(request.user.account.stripe_customer_id)
        token = request.POST.get('stripeToken', False)
        try:
            if token:
                card = customer.sources.create(source=token)
                customer.default_source = card.id
                customer.save()

                if request.POST.get('redirect', False):
                    return HttpResponseRedirect('/#/dashboard?ccupdate=true')

                return Response({'success': True})
        except:
                if request.POST.get('redirect', False):
                    return HttpResponseRedirect('/#/dashboard?ccupdate=false')

                return Response({'success': False})

class SubscriptionDetail(APIView):
    """
    GET to get a subscription, DELETE to unsubscribe
    """
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, pk):
        subscription = request.user.account.subscriptions.get(pk=pk)

        serializer = serializers.SubscriptionSerializer(subscription)

        return Response(serializer.data)

    def put(self, request, pk):
        data = serializers.SubscriptionChangeInputSerializer(data=request.data)

        if not data.is_valid():
            return Response(status=status.HTTP_400_BAD_REQUEST)

        subscription = request.user.account.subscriptions.get(pk=pk)
        subscription = subscription.change_subscription(data.data['plan_id'])

        serializer = serializers.SubscriptionSerializer(subscription)

        return Response(serializer.data)

    def delete(self, request, pk):
        subscription = request.user.account.subscriptions.get(pk=pk).unsubscribe()

        serializer = serializers.SubscriptionSerializer(subscription)

        return Response(serializer.data)

class Shares(APIView):
    """
    GET to view your shares, POST to create a share.
    """
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request):
        shares = request.user.account.shares.all().order_by('-created_date')

        sort = request.GET.get('order_by', '-created_date')
        shares = shares.order_by(sort)

        filter = request.GET.get('filter_by', '')
        if filter:
            shares = shares.filter(Q(name__icontains=filter) | Q(code__icontains=filter))

        paginator = pagination.MhPagination()
        share_page = paginator.paginate_queryset(shares, request)

        serializer = serializers.ShareDetailSerializer(share_page, many=True)
        return paginator.get_paginated_response(serializer.data)

    def post(self, request):
        account = request.user.account
        share_data = serializers.ShareInputSerializer(data=request.data)

        if not share_data.is_valid():
            return Response(status=status.HTTP_400_BAD_REQUEST)

        cardset = 'adult'

        if not share_data.data['emails']:
            share = account.create_share(cardset, share_data.data['quantity'], share_data.data['name'], individual=False)

            if not share:
                return Response(status=status.HTTP_402_PAYMENT_REQUIRED)

            serializer = serializers.ShareDetailSerializer(share)

        else:
            shares = []
            for email in share_data.data['emails']:
                share = account.create_share(cardset, 1, email, individual=True)
                host_url = full_url(request)
                shares.append(share)
                send_mail(
                    request,
                    email,
                    '{} sent you a Money Habitudes code'.format(request.user.account.name),
                    'share',
                    {
                        'host_url': full_url(request),
                        'share_url': full_url(request, '#/codes/{}'.format(share.code)),
                        'share_code': share.code,
                    },
                )

            serializer = serializers.ShareDetailSerializer(shares, many=True)

        return Response(serializer.data)

class ShareDetail(APIView):
    """
    GET the share, POST to claim it.
    """
    permission_classes = (permissions.AllowAny,)

    def get(self, request, code):
        try:
            share = Share.objects.get(code=code)
        except Share.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        if request.user.is_authenticated:
            account = request.user.account
        else:
            account = None

        serializer = serializers.ShareSerializer({'share': share, 'player': account})
        return Response(serializer.data)

    def post(self, request, code):
        share = Share.objects.get(code=code)

        cardset = Cardset.get_cardset('adult')

        if share.is_anonymous() == True:
            name = serializers.ShareAnonymousClaimInputSerializer(data=request.data)
            name.is_valid()
            if not request.user.is_authenticated:
                account = Account.create_anonymous_account(name.data['name'], language=pick_language(request))
                request.session.set_expiry(0)
            else:
                account = request.user.account

            game = Game.start_game(
                cardset = cardset,
                share = share,
                player = account)

            if game:
                login(request, account.user)
            elif account.anonymous:
                account.delete()

        elif request.user.is_authenticated:
            game = Game.start_game(
                cardset = cardset,
                share = share,
                player = request.user.account)

        else:
            return Response(status=status.HTTP_401_UNAUTHORIZED)

        if not game:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        game.language = pick_language(request)
        serializer = serializers.GameDetailSerializer(game)
        return Response(serializer.data)

    def put(self, request, code):
        share = request.user.account.shares.get(code=code)

        qty = request.data.get('new_total', None)
        name = request.data.get('name', None)

        if qty or qty == 0:
            try:
                share = share.change_qty(qty)
            except:
                return Response(status=status.HTTP_400_BAD_REQUEST)

        if name:
            try:
                share.name = name
                share.save()
            except:
                return Response(status=status.HTTP_400_BAD_REQUEST)

        if share:
            serializer = serializers.ShareDetailSerializer(share)
            return Response(serializer.data)
        else:
            return Response(status=status.HTTP_204_NO_CONTENT)

class AdminBranding(APIView):
    """
    GET user's branding data, POST new/updated branding data, DELETE to remove branding
    """
    permission_classes = (permissions.IsAuthenticated,)
    parser_classes = (MultiPartParser,FormParser,)

    def get(self, request):
        try:
            serializer = serializers.BrandingSerializer(request.user.account.branding)
            return Response(serializer.data)
        except:
            return Response({})

    def post(self, request):
        account = request.user.account
        image = request.data.get('cover_image', None)
        text = request.data.get('cover_text', '')
        redirect = request.data.get('redirect', False)
        delete_image = request.data.get('delete_image', False)

        try:
            branding = account.branding
            if delete_image == 'true':
                branding.full_delete()
                raise
            else:
                branding.cover_text = text
                branding.save()

        except:
            Branding.objects.create(
                account = account,
                cover_text = text,
                cover_image = image
            )

        if redirect:
            return HttpResponseRedirect('/#/settings?page=branding')
        else:
            return Response(status=status.HTTP_204_NO_CONTENT)

    def delete(self, request):
        account = request.user.account
        try:
            account.branding.cover_image.delete()
            account.branding.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except:
            return Response(status=status.HTTP_400_BAD_REQUEST)

class Feedback(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        name = request.data.get('name', None)
        email = request.data.get('email', None)
        message = request.data.get('message', None)
        trial = request.data.get('trial', False)
        org_name = request.data.get('org_name', None)
        phone = request.data.get('phone', None)

        subject = 'Money Habitudes Online inquiry - {}'
        if name:
            subject = subject.format(name)
        elif email:
            subject = subject.format(email)
        else:
            subject = subject.format('anonymous')

        send_mail(
            request,
            'info@lifewise.us',
            subject,
            'question', {
                'name': name,
                'email': email,
                'message': message,
                'trial': trial,
                'org_name': org_name,
                'phone': phone,
                'url': full_url(request),
            },
            email
        )

        return Response(status=status.HTTP_202_ACCEPTED)

class Language(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        language = pick_language(request, request.data.get('language'))
        if request.user.is_authenticated:
            a = request.user.account
            a.language = language
            a.save()
        else:
            request.session['language'] = language

        t = Translation(language)

        return Response({'web': t.strings['web']})