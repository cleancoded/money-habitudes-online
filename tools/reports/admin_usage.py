import csv
from datetime import date

from accounts.models import Account

table = [
    ['Name',
     'Email',
     'Used games',
     'Total games',
     'Group codes',
     'Admin reports',
     'Report branding',
     'Site branding',
     'Player pays',
     'Latest subscription',
     'Period end date',
     'Renews'],
    ]

accounts = Account.objects.filter(admin=True)
for account in accounts.all():
    row = [
        account.name,
        account.email,
        account.usage_stats()[0],
        account.usage_stats()[1],
        account.get_capabilities()['group_codes'],
        account.get_capabilities()['admin_reports'],
        account.get_capabilities()['report_branding'],
        account.get_capabilities()['site_branding'],
        account.player_pays,
        'N/A',
        'N/A',
        'N/A'
    ]

    if account.get_capabilities()['subscription']:
        row[9] = account.get_capabilities()['subscription']['stripe_plan_id']
        row[10] = account.get_capabilities()['subscription']['active_until'].isoformat()
        row[11] = account.get_capabilities()['subscription']['active']

    table.append(row)

today = date.today().isoformat()

with open('/tmp/admin.csv'.format(today), 'w', newline='', encoding='utf8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerows(table)
