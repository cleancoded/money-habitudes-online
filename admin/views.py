from django.conf import settings
from django.contrib.admin.views.decorators import staff_member_required
from django.core.paginator import Paginator
from django.db.models import Q
from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import render
import markdown
import os
import stripe
import xlwt

from accounts.models import Account, Share
from games.models import Game

stripe.api_key = settings.STRIPE_SECRET_KEY

@staff_member_required
def index(request):
    return account_list(request)

def login(request):
    return HttpResponseRedirect('/#/login')

@staff_member_required
def account_list(request):
    accounts = Account.objects.all()
    page_number = request.GET.get('page', 1)
    search_text = request.GET.get('q', '')
    order_by = request.GET.get('order_by', 'email')
    show_admin_accounts_only = request.GET.get('show_admin_accounts_only', False)
    show_admin_accounts_only = True if show_admin_accounts_only == True or show_admin_accounts_only == 'True' else False
    show_test_accounts = request.GET.get('show_test_accounts', False)
    show_test_accounts = True if show_test_accounts == True or show_test_accounts == 'True' else False
    show_anonymous_accounts = request.GET.get('show_anonymous_accounts', False)
    show_anonymous_accounts = True if show_anonymous_accounts == True or show_anonymous_accounts == 'True' else False
    if search_text:
        accounts = accounts.filter(Q(email__icontains=search_text) |
                                   Q(name__icontains=search_text) |
                                   Q(stripe_customer_id__icontains=search_text))
    if show_admin_accounts_only:
        accounts = accounts.filter(admin=True)
    if not show_test_accounts:
        accounts = accounts.exclude(email__icontains='@example')
    if not show_anonymous_accounts:
        accounts = accounts.exclude(email__icontains='@localhost')
    accounts = accounts.order_by(order_by)
    if request.method == 'POST':
        account = Account.create_account(
            request.POST.get('email'),
            'event1010',
            request.POST.get('name'),
        )
        account.email_confirmed = True if request.POST.get('email_confirmed') == 'on' else False
        account.enforce_limits = True if request.POST.get('enforce_limits') == 'on' else False
        account.group_code_override = True if request.POST.get('group_code_override') == 'on' else False
        account.admin_report_override = True if request.POST.get('admin_report_override') == 'on' else False
        account.report_branding = True if request.POST.get('report_branding') == 'on' else False
        account.site_branding = True if request.POST.get('site_branding') == 'on' else False
        account.player_pays = True if request.POST.get('player_pays') == 'on' else False
        account.hide_player_reports = True if request.POST.get('hide_player_reports') == 'on' else False
        account.player_report_alt_message = request.POST.get('player_report_alt_message', account.player_report_alt_message)
        account.set_bonus_games_count(int(request.POST.get('bonus_games_count', account.get_bonus_games_count())))
        account.save()

    return render(request, 'admin/accounts.html', {
        'page': Paginator(accounts, 50).page(page_number),
        'search_text': search_text,
        'order_by': order_by,
        'show_test_accounts': show_test_accounts,
        'show_anonymous_accounts': show_anonymous_accounts,
        'show_admin_accounts_only': show_admin_accounts_only,
    })

@staff_member_required
def account_detail(request, pk):
    account = Account.objects.get(pk=pk)
    if request.method == 'POST':
        account.name = request.POST.get('name', account.name)
        account.set_email(request.POST.get('email', account.email))
        account.email_confirmed = True if request.POST.get('email_confirmed') == 'on' else False
        account.enforce_limits = True if request.POST.get('enforce_limits') == 'on' else False
        account.group_code_override = True if request.POST.get('group_code_override') == 'on' else False
        account.admin_report_override = True if request.POST.get('admin_report_override') == 'on' else False
        account.report_branding = True if request.POST.get('report_branding') == 'on' else False
        account.site_branding = True if request.POST.get('site_branding') == 'on' else False
        account.player_pays = True if request.POST.get('player_pays') == 'on' else False
        account.anonymous_games = True if request.POST.get('anonymous_games') == 'on' else False
        account.show_next_steps = True if request.POST.get('show_next_steps') == 'on' else False
        account.extra_languages = True if request.POST.get('extra_languages') == 'on' else False
        if account.report_end:
            if request.POST.get('delete_report_end') == 'on' or request.FILES.get('report_end'):
                if os.path.isfile(account.report_end.path):
                    os.remove(account.report_end.path)
                account.report_end.delete()
        if request.FILES.get('report_end'):
            account.report_end.save('report_end.pdf', request.FILES['report_end'])
        account.hide_player_reports = True if request.POST.get('hide_player_reports') == 'on' else False
        account.player_report_alt_message = request.POST.get('player_report_alt_message', account.player_report_alt_message)
        account.set_bonus_games_count(int(request.POST.get('bonus_games_count', account.get_bonus_games_count())))
        account.save()

    return render(request, 'admin/account_detail.html', {
        'account': account,
        'capabilities': account.get_capabilities(),
        'subscriptions_preview': account.subscriptions.order_by('created_date'),
        'shares_preview': Paginator(account.shares.order_by('created_date'), 5).page(1),
        'games_preview': Paginator(Game.objects.filter(Q(owner=account) | Q(player=account)).order_by('created_date'), 5).page(1),
    })

@staff_member_required
def account_detail_shares(request, pk):
    account = Account.objects.get(pk=pk)
    shares = account.shares.all()
    page_number = request.GET.get('page', 1)
    search_text = request.GET.get('q', '')
    order_by = request.GET.get('order_by', 'created_date')
    if search_text:
        shares = shares.filter(Q(code__icontains=search_text) |
                               Q(name__icontains=search_text))
    shares = shares.order_by(order_by)
    return render(request, 'admin/shares.html', {
        'account': account,
        'page': Paginator(shares, 50).page(page_number),
        'search_text': search_text,
        'order_by': order_by,
    })

@staff_member_required
def account_detail_games(request, pk):
    account = Account.objects.get(pk=pk)
    games = Game.objects.filter(Q(owner=account) | Q(player=account))
    page_number = request.GET.get('page', 1)
    search_text = request.GET.get('q', '')
    order_by = request.GET.get('order_by', 'created_date')
    if search_text:
        games = games.filter(Q(player_name__icontains=search_text) |
                               Q(player_email__icontains=search_text) |
                               Q(share_name__icontains=search_text))
    games = games.order_by(order_by)
    return render(request, 'admin/games.html', {
        'page': Paginator(games, 50).page(page_number),
        'search_text': search_text,
        'order_by': order_by,
    })

@staff_member_required
def share_list(request):
    shares = Share.objects.all()
    page_number = request.GET.get('page', 1)
    search_text = request.GET.get('q', '')
    order_by = request.GET.get('order_by', 'created_date')
    if search_text:
        shares = shares.filter(Q(code__icontains=search_text) |
                               Q(name__icontains=search_text))
    shares = shares.order_by(order_by)
    return render(request, 'admin/shares.html', {
        'page': Paginator(shares, 50).page(page_number),
        'search_text': search_text,
        'order_by': order_by,
    })

@staff_member_required
def share_detail(request, pk):
    share = Share.objects.get(pk=pk)

    if request.method == 'POST':
        share.name = request.POST.get('name', share.name)
        share.code = request.POST.get('code', share.code)
        share.save()

    return render(request, 'admin/share_detail.html', {
        'share': share,
        'games_preview': Paginator(Game.objects.filter(share=share).order_by('created_date'), 5).page(1),
    })


@staff_member_required
def share_detail_games(request, pk):
    share = Share.objects.get(pk=pk)
    games = Game.objects.filter(share=share)
    page_number = request.GET.get('page', 1)
    search_text = request.GET.get('q', '')
    order_by = request.GET.get('order_by', 'created_date')
    if search_text:
        games = games.filter(Q(player_name__icontains=search_text) |
                               Q(player_email__icontains=search_text) |
                               Q(share_name__icontains=search_text))
    games = games.order_by(order_by)
    return render(request, 'admin/games.html', {
        'page': Paginator(games, 50).page(page_number),
        'search_text': search_text,
        'order_by': order_by,
    })

@staff_member_required
def game_list(request):
    games = Game.objects.all()
    page_number = request.GET.get('page', 1)
    search_text = request.GET.get('q', '')
    order_by = request.GET.get('order_by', 'created_date')
    if search_text:
        games = games.filter(Q(player_name__icontains=search_text) |
                               Q(player_email__icontains=search_text) |
                               Q(share_name__icontains=search_text))
    games = games.order_by(order_by)
    return render(request, 'admin/games.html', {
        'page': Paginator(games, 50).page(page_number),
        'search_text': search_text,
        'order_by': order_by,
    })

@staff_member_required
def product_list(request):
    stripe_plans = stripe.Plan.list()
    plans = []
    for plan in stripe_plans:
        try:
            cardset = Cardset.objects.get(pk=plan['metadata']['cardset'])
            plans.append({
                'id': plan['id'],
                'amount': plan['amount'],
                'created': plan['created'],
                'currency': plan['currency'],
                'interval': plan['interval'],
                'livemode': plan['livemode'],
                'name': plan['name'],
                'statement_descriptor': plan['statement_descriptor'],
                'trial_period_days': plan['trial_period_days'],
                'games': plan['metadata']['games']
            })
        except:
            pass

    stripe_products = stripe.Product.list()
    products = []
    for product in stripe_products:
        try:
            cardset = Cardset.objects.get(pk=product['metadata']['cardset'])
            products.append({
                'id': product['id'],
                'active': product['active'],
                'description': product['description'],
                'name': product['name'],
                'games': product['metadata']['games'],
            })
        except:
            pass

    return render(request, 'admin/products.html', {
        'plans': plans,
        'products': products,
    })

@staff_member_required
def report_list(request):
    return render(request, 'admin/report_list.html')

@staff_member_required
def report_game_usage(request):
    accounts = Account.objects.filter(user__is_active=True)
    page_number = request.GET.get('page', 1)
    search_text = request.GET.get('q', '')
    order_by = request.GET.get('order_by', 'email')
    if search_text:
        accounts = accounts.filter(Q(email__icontains=search_text) |
                                   Q(name__icontains=search_text) |
                                   Q(stripe_customer_id__icontains=search_text))
    accounts = accounts.order_by(order_by)
    return render(request, 'admin/reports/game_usage.html', {
        'page': Paginator(accounts, 50).page(page_number),
        'search_text': search_text,
        'order_by': order_by,
    })

@staff_member_required
def report_admin_usage(request):
    accounts = Account.objects.filter(admin=True)
    page_number = request.GET.get('page', 1)
    search_text = request.GET.get('q', '')
    order_by = request.GET.get('order_by', 'email')
    if search_text:
        accounts = accounts.filter(Q(email__icontains=search_text) |
                                   Q(name__icontains=search_text) |
                                   Q(stripe_customer_id__icontains=search_text))
    accounts = accounts.order_by(order_by)
    return render(request, 'admin/reports/admin_usage.html', {
        'page': Paginator(accounts, 50).page(page_number),
        'search_text': search_text,
        'order_by': order_by,
    })


@staff_member_required
def export_game_list(request):
    response = HttpResponse(content_type='application/ms-excel')
    response['Content-Disposition'] = 'attachment; filename="games.xls"'

    wb = xlwt.Workbook(encoding='utf-8')
    ws = wb.add_sheet('Users')

    # Sheet header, first row
    row_num = 0

    font_style = xlwt.XFStyle()
    font_style.font.bold = True

    columns = ['Owner', 'Player', 'Started', 'Completed' ]

    for col_num in range(len(columns)):
        ws.write(row_num, col_num, columns[col_num], font_style)

    # Sheet body, remaining rows
    font_style = xlwt.XFStyle()

    rows = Game.objects.all()
    for game in rows:
        row_num += 1
        complete_status = 'True' if game.completed else "False"
        started = game.created_date.strftime("%b %d, %Y, %H:%m %p")

        ws.write(row_num, 0, game.owner.email, font_style)
        ws.write(row_num, 1, game.player.email, font_style)
        ws.write(row_num, 2, started, font_style)
        ws.write(row_num, 3, complete_status, font_style)

    wb.save(response)
    return response
