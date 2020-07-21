import csv
import os
import json

from collections import defaultdict

from django.conf import settings

IN_PATH = os.path.join(settings.BASE_DIR, 'language/translations')
OUT_PATH = os.path.join(settings.BASE_DIR, 'language/translations')
WEB_PATH = os.path.join(settings.BASE_DIR, 'static/language')

LANGUAGE_CHOICES = [
    ('en_US', 'English'),
    ('es_ES', 'Español'),
]

LANGUAGE_DEBUG = [
    ('zz_ZZ', 'Cursive'),
    ('de_DE', 'Deutsch'),
]

def pick_language(request, language=''):
    choices = [i[0] for i in LANGUAGE_CHOICES + LANGUAGE_DEBUG]
    if language and language in choices:
        return language
    elif request.user.is_authenticated and request.user.account.language in choices:
        return request.user.account.language
    elif request.session.get('language') and request.session.get('language') in choices:
        return request.session.get('language')
    else:
        languages = parse_accept(request.META.get('HTTP_ACCEPT_LANGUAGE', 'en-US'))
        for language in languages:
            for choice in choices:
                if language == choice:
                    return choice
                elif language == choice[0:2]:
                    return choice
                elif len(language) >= 2 and language[0:2] == choice[0:2]:
                    return choice

        return 'en_US'

def parse_accept(s):
    response = []
    languages = s.split(',')
    for language in languages:
        if language.split(';') == language:
            response.append(language.replace('-', '_').strip())
        else:
            response.append(language.split(';')[0].replace('-', '_').strip())

    return response


nested_dict = lambda: defaultdict(nested_dict)

def build():
    """
    Creates json files for all csv origin files in the translations directory.
    """
    for root, dirs, files in os.walk(IN_PATH):
        for filename in files:
            if filename.endswith('.csv'):
                with open(os.path.join(IN_PATH, filename), encoding='utf-8') as f:
                    reader = csv.reader(f)
                    next(reader)
                    data = nested_dict()
                    web_data = nested_dict()
                    for row in reader:
                        if row[0].startswith('report.') or row[0].startswith('cardset.'):
                            d = data
                        elif row[0].startswith('web.'):
                            d = web_data
                        path = row[0].split('.')
                        for i in range(len(path)):
                            if i == len(path) - 1:
                                d[path[i]] = row[1]
                            else:
                                d = d[path[i]]
                    with open (os.path.join(OUT_PATH, filename.replace('.csv', '.json')), 'w', encoding='utf-8') as fout:
                        json.dump({**data, **web_data}, fout)
                    with open (os.path.join(WEB_PATH, filename.replace('.csv', '.js')), 'w', encoding='utf-8') as fout:
                        fout.write('var STRINGS = {};'.format(json.dumps(web_data)))

    with open(os.path.join(IN_PATH, 'en_US.csv'), encoding='utf-8') as f:
        reader = csv.reader(f)
        next(reader)
        data = nested_dict()
        web_data = nested_dict()
        for row in reader:
            path = row[0].split('.')
            if row[0].startswith('report.') or row[0].startswith('cardset.'):
                d = data
            elif row[0].startswith('web.'):
                d = web_data

            for i in range(len(path)):
                if i == len(path) - 1:
                    d[path[i]] = zz_string(row[1], row[0])
                else:
                    d = d[path[i]]
        with open(os.path.join(OUT_PATH, 'zz_ZZ.json'), 'w', encoding='utf-8') as fout:
            json.dump({**data, **web_data}, fout)
        with open(os.path.join(WEB_PATH, 'zz_ZZ.js'), 'w', encoding='utf-8') as fout:
            fout.write('var STRINGS = {};'.format(json.dumps(web_data)))

def zz_string(string, identifier):
    if identifier == 'report.date_format':
        return '%Y-%m-%d'

    response = ''
    bracket = False
    literal = False
    literal_end = ''
    for i in range(len(string)):
        if string[i] == '{':
            literal = True
            literal_end = '}'
        elif string[i] == '&' and (
            string[i:i+6] == '&nbsp;' or
            string[i:i+6] == '&bull;' or
            string[i:i+5] == '&amp;' or
            string[i:i+6] == '&copy;' or
            string[i:i+5] == '&reg;'
        ):
            literal = True
            literal_end = ';'
        if literal:
            if string[i] == literal_end:
                literal = False;
            response = response + string[i]
        elif string[i] >= 'a' and string[i] <= 'z':
            response = response + chr(120042 - ord('a') + ord(string[i]))
        elif string[i] >= 'A' and string[i] <= 'Z':
            response = response + chr(120016 - ord('A') + ord(string[i]))
        else:
            response = response + string[i]

    return response

class Translation():
    def __init__(self, locale='en_US'):
        self.locale = locale
        self.strings = Translation.load(locale)

    def load(locale):
        """
        Loads a locale from json file.
        FileNotFound exception if locale does not exist or is not built.

        :locale: Name of the locale
        """
        if not locale:
            locale = 'en_US'
        filepath = os.path.join(OUT_PATH, locale + '.json')
        with open(filepath, encoding='utf-8') as f:
            return json.load(f)

    def gettext(self, identifier, **kwargs):
        path = identifier.split('.')
        s = self.strings
        try:
            for key in path:
                s = s[key]
            return s.format(**kwargs)
        except KeyError:
            if self.locale != 'en_US':
                t = Translation(locale='en_US')
                response = t.gettext(identifier, **kwargs)
            else:
                return '[String not found.]'
        return response
