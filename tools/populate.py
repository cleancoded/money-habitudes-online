from django.conf import settings
from django.utils import timezone
import random
import stripe

from accounts.models import Account, Share
from cards.models import Cardset
from orders.models import Subscription
from games.models import Game

from tools.names import get_person_name, get_project_name

stripe.api_key = settings.STRIPE_SECRET_KEY

class Person:
    def __init__(self, email=None):
        if email:
            self.obj = Account.objects.get(email=email)
        else:
            name = get_person_name()
            email = '{}@example.com'.format(name.lower().replace(' ', '.'))
            password = 'test'
            while Account.objects.filter(email=email).count() > 0:
                name = get_person_name()
                email = '{}@example.com'.format(name.lower().replace(' ', '.'))

            self.obj = Account.create_account(email, password, name)

    def subscribe(self):
        # Get most expensive plan
        plans = stripe.Plan.list()
        planset = []
        for plan in plans:
            try:
                plan['metadata']['games']
                planset.append(plan)
            except:
                pass
        planset.sort(key=lambda x: x['amount'])
        plan = planset[-1]

        # Create charge token
        token = stripe.Token.create(
            card = {
                'number': '4242424242424242',
                'exp_month': 12,
                'exp_year': 2020,
                'cvc': '123',
            },
        )

        # Subscribe
        customer = stripe.Customer.create(
            source = token.id,
            plan = plan.id,
            email = self.obj.email,
        )
        self.obj.stripe_customer_id = customer['id']
        self.obj.save()

        subscription = customer['subscriptions']['data'][0]

        subscription = Subscription.objects.create(
            account = self.obj,
            active_until = timezone.datetime.fromtimestamp(customer['subscriptions']['data'][0]['current_period_end'], tz=timezone.UTC()),
            stripe_subscription_id = subscription['id'],
            stripe_plan_id = subscription['plan']['id'],
            stripe_plan_name = subscription['plan']['name'],
        )

        subscription.refresh_subscription(True)

    def play(self, share):
        game = Game.start_game(share, self.obj)

        cards = game.cardset.cards.all()

        for card in cards:
            game.answer(card, random.choice([-1, 0, 1]))

        game.date = timezone.now() - timezone.timedelta(days=random.randrange(0, 365))
        game.save()

def populate(email=None, players=100, available_games=100):
    # Create admin
    admin = Person(email)
    print('Admin:\n{} <{}>'.format(admin.obj.name, admin.obj.email))
    #admin.subscribe()
    admin.obj.add_games(available_games)

    # Create clients
    clients = []
    print('Clients:')
    for i in range(players):
        client = Person()
        clients.append(client)

    # Make shares and play games until all clients have played one game
    cardset = Cardset.objects.first()
    while len(clients) > 0:
        group_max = 20
        if group_max > len(clients):
            group_max = len(clients)

        if group_max > 1:
            group_size = random.randrange(1, group_max)
        else:
            group_size = 1

        users = []
        for i in range(group_size):
            users.append(clients.pop())

        if (group_size == 1):
            share = admin.obj.create_share(cardset, group_size, users[0].obj.email)
        else:
            share = admin.obj.create_share(cardset, group_size, get_project_name())

        for user in users:
            user.play(share)
            print('{} <{}>'.format(user.obj.name, user.obj.email))

    print('Completed. Admin is {} <{}>'.format(admin.obj.name, admin.obj.email))

def reset():
    accounts = Account.objects.filter(email__contains='@example.com')
    for account in accounts:
        if account.stripe_customer_id:
            customer = stripe.Customer.retrieve(account.stripe_customer_id)
            customer.delete()
        account.user.delete()
        account.delete()
