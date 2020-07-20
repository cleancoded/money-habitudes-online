import csv

from cards.models import Cardset, CardsetVersion, Report

def importCardset(filepath):
    data = readFile(filepath)

    Cardset.create_or_update(data)

def readFile(filepath):
    data = {
        'cardset': {},
        'cardsetprices': [],
        'categories': [],
        'cards': [],
        'report': {},
    }

    with open(filepath, newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        for row in reader:
            if row[0].lower() == 'cardset':
                loadCardset(row, data)
            elif row[0].lower() == 'cardsetprice':
                loadCardsetPrice(row, data)
            elif row[0].lower() == 'cardcategory':
                loadCardCategory(row, data)
            elif row[0].lower() == 'card':
                loadCard(row, data)
            elif row[0].lower().startswith('report'):
                loadReport(row, data)

    csvfile.close()

    return data

def loadCardset(row, data):
    data['cardset']['name'] = row[1]
    data['cardset']['description'] = row[2]

def loadCardsetPrice(row, data):
    data['cardsetprices'].append({
        'min_qty': row[1],
        'unit_price': row[2],
    })

def loadCardCategory(row, data):
    data['categories'].append({
        'name': row[1],
        'description': row[2],
    })

def loadCard(row, data):
    data['cards'].append({
        'category': row[1],
        'text': row[2],
    })

def loadReport(row, data):
    if data['report'] == {}:
        data['report'] = {
            'version': 0,
            'summary': {},
            'meaning': {},
            'advantages': {},
            'challenges': {},
            'how_others_see_you': {},
            'general': {},
            'missing': {},
            'dominant': {},
            'behaviors': {},
            'next_steps': {},
        }

    rowType = row[0].lower()
    if rowType == 'reportversion':
        data['report']['version'] = row[1]

    elif rowType == 'reportsummary':
        category = row[1].lower()
        minCount = int(row[2])
        message = row[3]

        if category not in data['report']['summary']:
            data['report']['summary'][category] = []

        data['report']['summary'][category].append({
            'min_count': minCount,
            'message': message,
        })

    elif rowType == 'reportmeaning':
        category = row[1].lower()
        minCount = int(row[2])
        message = row[3]

        if category not in data['report']['meaning']:
            data['report']['meaning'][category] = []

        data['report']['meaning'][category].append({
            'min_count': minCount,
            'message': message,
        })

    elif rowType == 'reportadvantages':
        category = row[1].lower()
        message = row[2]

        data['report']['advantages'][category] = message

    elif rowType == 'reportchallenges':
        category = row[1].lower()
        message = row[2]

        data['report']['challenges'][category] = message

    elif rowType == 'reporthowothersseeyou':
        category = row[1].lower()
        message = row[2]

        data['report']['how_others_see_you'][category] = message

    elif rowType == 'reportgeneralquestions':
        category = row[1].lower()
        message = row[2]

        data['report']['general'][category] = message

    elif rowType == 'reportmissinghabitudequestions':
        category = row[1].lower()
        message = row[2]

        data['report']['missing'][category] = message

    elif rowType == 'reportdominanthabitudequestions':
        category = row[1].lower()
        message = row[2]

        data['report']['dominant'][category] = message

    elif rowType == 'reportdominantbehaviors':
        category = row[1].lower()
        behavior = row[2].lower()
        message = row[3]

        if category not in data['report']['behaviors']:
            data['report']['behaviors'][category] = {}

        data['report']['behaviors'][category][behavior] = message

    elif rowType == 'reportnextsteps':
        category = row[1].lower()
        message = row[2]

        data['report']['next_steps'][category] = message
