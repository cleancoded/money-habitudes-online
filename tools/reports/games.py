import csv
import errno
import os
from uuid import uuid4

from accounts.models import Account
from games.models import Game

def generate_report(email=None):
    table = [[
        'Date completed',
        'Share name',
        'Share code',
        'Player name',
        'Player email',
        'Carefree - Not me',
        'Carefree - Sometimes me',
        'Carefree - That\'s me',
        'Giving - Not me',
        'Giving - Sometimes me',
        'Giving - That\'s me',
        'Planning - Not me',
        'Planning - Sometimes me',
        'Planning - That\'s me',
        'Security - Not me',
        'Security - Sometimes me',
        'Security - That\'s me',
        'Spontaneous - Not me',
        'Spontaneous - Sometimes me',
        'Spontaneous - That\'s me',
        'Status - Not me',
        'Status - Sometimes me',
        'Status - That\'s me',
    ]]

    games = Game.objects.filter(completed=True)
    if email:
        games = games.filter(owner=Account.objects.get(email=email))
    else:
        email = 'syble'
    
    for g in games:
        table.append([
            g.modified_date.isoformat(),
            g.share.name,
            g.share.code,
            g.player.name,
            g.player.email,
            g.data['categories']['ca']['-1'],
            g.data['categories']['ca']['0'],
            g.data['categories']['ca']['1'],
            g.data['categories']['gi']['-1'],
            g.data['categories']['gi']['0'],
            g.data['categories']['gi']['1'],
            g.data['categories']['pl']['-1'],
            g.data['categories']['pl']['0'],
            g.data['categories']['pl']['1'],
            g.data['categories']['se']['-1'],
            g.data['categories']['se']['0'],
            g.data['categories']['se']['1'],
            g.data['categories']['sp']['-1'],
            g.data['categories']['sp']['0'],
            g.data['categories']['sp']['1'],
            g.data['categories']['st']['-1'],
            g.data['categories']['st']['0'],
            g.data['categories']['st']['1'],
        ])

    filepath = 'static/media/reports/{}/{}.csv'.format(str(uuid4()), email.split('@')[0])
    if not os.path.exists(os.path.dirname(filepath)):
        try:
            os.makedirs(os.path.dirname(filepath))
        except OSError as exc: # Guard against race condition
            if exc.errno != errno.EEXIST:
                raise

    with open(filepath, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerows(table)
    
    print(filepath)