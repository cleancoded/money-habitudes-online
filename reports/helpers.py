from django.conf import settings
from django.template.defaulttags import register
from django.template.loader import render_to_string
from io import BytesIO
from rest_framework.utils.serializer_helpers import ReturnDict
from tempfile import TemporaryFile
from weasyprint import HTML
import base64
import datetime
import json
import locale
import logging
import markdown

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

from api_beta.serializers import GameSerializer
from cards.cardset import Cardset
from language import Translation, pick_language
from reports.serializers import ReportSerializer

logger = logging.getLogger(__name__)

@register.filter
def get_item(dictionary, key):
    return dictionary.get(key)

def to_pdf(request, game, show_cover=True, show_dynamic=True, show_next_steps=True):
    colors = {
        'ca': '#f9ed21',
        'gi': '#468041',
        'pl': '#23428f',
        'se': '#788693',
        'sp': '#d02e35',
        'st': '#854b9a',
    };
    language = pick_language(request)
    t = Translation(language)
    strings = t.strings

    cardset = Cardset.get_cardset(name=game.cardset)
    results = game.data['categories']

    thatsme_cards = 0
    for key in results:
        thatsme_cards += results[key]['1']

    sorted_categories = sorted(results.items(), key=lambda x: x[1]['1'], reverse=True)
    category_strings = []
    for category in sorted_categories:
        category_data = {}
        category_data['results'] = category[1]
        category_data['id'] = category[0]
        category_data['name'] = t.gettext('cardset.adult.category.{}.name'.format(category[0]))
        category_data['description'] = t.gettext('cardset.adult.category.{}.description'.format(category[0]))

        if results[category[0]]['1'] >= 7:
            level = 'high'
        elif results[category[0]]['1'] >= 4:
            level = 'medium'
        elif results[category[0]]['1'] >= 1:
            level = 'low'
        else:
            level = 'missing'

        category_data['summary'] = t.gettext('report.adult.summary.{}.{}'.format(category[0], level))

        meaning_level = level if level != 'high' else 'medium'
        category_data['meaning'] = markdown.markdown(t.gettext('report.adult.meaning.{}.{}'.format(category[0], meaning_level)))

        category_data['advantages'] = markdown.markdown(t.gettext('report.adult.advantages.{}'.format(category[0])))
        category_data['challenges'] = markdown.markdown(t.gettext('report.adult.challenges.{}'.format(category[0])))
        category_data['hose'] = markdown.markdown(t.gettext('report.adult.hose.{}'.format(category[0])))
        category_data['general'] = markdown.markdown(t.gettext('report.adult.general.{}'.format(category[0])))

        if level == 'missing':
            category_data['missing'] = markdown.markdown(t.gettext('report.adult.missing.{}'.format(category[0])))

        if meaning_level == 'medium':
            category_data['dominant'] = markdown.markdown(t.gettext('report.adult.dominant.{}'.format(category[0])))

        category_data['next'] = markdown.markdown(t.gettext('report.adult.next.{}'.format(category[0])))
        category_data['never_count'] = results[category[0]]['-1']
        category_data['sometimes_count'] = results[category[0]]['0']
        category_data['always_count'] = results[category[0]]['1']

        category_strings.append(category_data)

    try:
        locale.setlocale(locale.LC_ALL, '{}.utf8'.format(language))
    except:
        locale.setlocale(locale.LC_ALL, 'en_US.utf8')

    last_activity_date_formatted = game.last_activity_date.strftime(t.gettext('report.date_format'))
    copyright_string = t.gettext('report.adult.cover.footer.copyright', year=datetime.datetime.now().year)
    page_string = t.gettext('report.page_count', counter='counter(page)')
    report_table_subtitle_string = t.gettext('report.adult.pg3.table.subtitle', cards=thatsme_cards)

    context = {
        'game': game,
        'colors': colors,
        'categories': cardset.categories,
        'category_strings': category_strings,
        'sorted_categories': sorted_categories,
        'results': results,
        'thatsme_cards': thatsme_cards,
        'show_cover': show_cover,
        'show_dynamic': show_dynamic,
        'show_next_steps': show_next_steps,
        't': t.strings,
        'last_activity_date_formatted': last_activity_date_formatted,
        'copyright_string': copyright_string,
        'page_string': page_string,
        'report_table_subtitle_string': report_table_subtitle_string
    }
    template_string = render_to_string('reports/user.html', context)
    html = HTML(string=template_string, base_url=settings.BASE_DIR)
    main_doc = html.render()
    return main_doc.write_pdf()

def sample_cover(request):
    language = pick_language(request)
    t = Translation(language)
    game = {'player': {'name': 'Jane Doe'}, 'owner': request.user.account}

    try:
        locale.setlocale(locale.LC_ALL, '{}.utf8'.format(language))
    except:
        locale.setlocale(locale.LC_ALL, 'en_US.utf8')

    last_activity_date_formatted = datetime.datetime.now().strftime(t.gettext('report.date_format'))
    copyright_string = t.gettext('report.adult.cover.footer.copyright', year=datetime.datetime.now().year)
    page_string = t.gettext('report.page_count', counter='counter(page)')

    context = {
        'game': game,
        'show_cover': True,
        't': t.strings,
        'last_activity_date_formatted': last_activity_date_formatted,
        'copyright_string': copyright_string,
        'page_string': page_string,
    }
    template_string = render_to_string('reports/user.html', context)
    html = HTML(string=template_string, base_url=settings.BASE_DIR)
    main_doc = html.render()
    return main_doc.write_pdf()

def professional_report(request, game):
    language = pick_language(request)
    t = Translation(language)
    strings = t.strings
    report = GameSerializer(game).data
    cardset = Cardset.get_cardset(name=game.cardset)
    results = game.data['categories']
    sorted_categories = sorted(results.items(), key=lambda x: x[1]['1'], reverse=True)

    colors = {
        'ca': ['#e0b901', '#f9d93b', '#fbf1ae'],
        'gi': ['#51a60f', '#98d06d', '#c8f2ac'],
        'pl': ['#224192', '#4e68b7', '#bcccfe'],
        'se': ['#687683', '#96a1ac', '#dde2e7'],
        'sp': ['#ee001a', '#e35361', '#ffc7ce'],
        'st': ['#a03a90', '#c966ba', '#fcc7f3'],
    };
    statement_distribution = []
    total_counts = {
        'me': 0,
        'some': 0,
        'not': 0,
    }
    thatsme_chart_data = []
    someme_chart_data = []
    notme_chart_data = []
    thatsme_chart_colors = []
    someme_chart_colors = []
    notme_chart_colors = []
    category_charts = []
    swatch = [[], [], []]
    has = {'me': False, 'some': False, 'not': False}
    category_labels = {}
    for category in sorted_categories:
        category_labels[category[0]] = t.gettext(cardset.categories[category[0]]['strings']['description'])
    card_results = []
    for item in sorted_categories:
        statement_distribution.append((
            item[0], {
                'not': item[1]['-1'],
                'some': item[1]['0'],
                'me': item[1]['1'],
            },
            t.gettext(cardset.categories[item[0]]['strings']['name'])
        ))

        card_result = [item[0], category_labels[item[0]], [[], [], []], colors[item[0]]]

        cards = cardset._cards
        category_cards = [i for i, s in enumerate(cards) if item[0] in s]
        answers = game.data['answers']
        for index in category_cards:
            answer = answers[index]
            if answer == 1:
                card_result[2][0].append(
                    t.gettext('cardset.adult.card.{}'.format(cards[index]))
                )
                has['me'] = True
            elif answer == 0:
                card_result[2][1].append(
                    t.gettext('cardset.adult.card.{}'.format(cards[index]))
                )
                has['some'] = True
            else:
                card_result[2][2].append(
                    t.gettext('cardset.adult.card.{}'.format(cards[index]))
                )
                has['not'] = True

        card_results.append(card_result)

        if item[1]['1']:
            thatsme_chart_data.append(item[1]['1'])
            thatsme_chart_colors.append(colors[item[0]][0])
            total_counts['me'] += item[1]['1']
        if item[1]['0']:
            someme_chart_data.append(item[1]['0'])
            someme_chart_colors.append(colors[item[0]][0])
            total_counts['some'] += item[1]['0']
        if item[1]['-1']:
            notme_chart_data.append(item[1]['-1'])
            notme_chart_colors.append(colors[item[0]][0])
            total_counts['not'] += item[1]['-1']

        if item[1]['1'] + item[1]['0'] + item[1]['-1'] > 0:
            itemdata = []
            itemcolors = []

            if item[1]['1'] > 0:
                itemdata.append(item[1]['1'])
                itemcolors.append(colors[item[0]][0])
            if item[1]['0'] > 0:
                itemdata.append(item[1]['0'])
                itemcolors.append(colors[item[0]][1])
            if item[1]['-1'] > 0:
                itemdata.append(item[1]['-1'])
                itemcolors.append(colors[item[0]][2])

            category_charts.append(make_pie_chart(itemdata, itemcolors))
            swatch[0].append(colors[item[0]][0])
            swatch[1].append(colors[item[0]][1])
            swatch[2].append(colors[item[0]][2])

    thatsme_chart = make_pie_chart(thatsme_chart_data, thatsme_chart_colors)
    someme_chart = make_pie_chart(someme_chart_data, someme_chart_colors)
    notme_chart = make_pie_chart(notme_chart_data, notme_chart_colors)

    context = {
        'game': game,
        'statement_distribution': statement_distribution,
        'total_counts': total_counts,
        'charts': {
            'thatsme': thatsme_chart,
            'someme': someme_chart,
            'notme': notme_chart,
        },
        'category_charts': category_charts,
        'swatch': swatch,
        'card_results': card_results,
        'has': has,
    }
    template_string = render_to_string('reports/professional.html', context)
    html = HTML(string=template_string, base_url=settings.BASE_DIR)
    main_doc = html.render()
    return main_doc.write_pdf()

def recursive_markdown(level):
    if type(level) == str:
        level = markdown.markdown(level)
    elif type(level) == list:
        for i in range(len(level)):
            level[i] = recursive_markdown(level[i])
    elif type(level) == dict or type(level) == ReturnDict:
        for key in level.keys():
            level[key] = recursive_markdown(level[key])
    else:
        logger.error('recursive_markdown failed! Unexpected type {}'.format(type(level)))

    return level

def make_pie_chart(values, colors):
    p, tx,  autotexts = plt.pie(values, colors=colors, autopct="", startangle=90, counterclock=False)

    for i, a in enumerate(autotexts):
        a.set_text('{}'.format(values[i]))
        a.set_fontsize(22)

    plt.axis('equal')
    imgdata = BytesIO()
    plt.savefig(imgdata)
    plt.clf()
    return base64.b64encode(imgdata.getvalue()).decode()
