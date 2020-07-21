from rest_framework import serializers
import json

from cards.cardset import Cardset
from language import Translation

class ReportSerializer(serializers.Serializer):
    def to_representation(self, game):
        results = game.data['categories']
        results_list = list(results.items())
        translation = Translation()
        strings = translation.strings

        report = {
            'categories': {},
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

        for category in results_list:
            report['categories'][category[0]] = {
                'name': strings['cardset.adult.category.{}.name'.format(category[0])],
                'description': strings['cardset.adult.category.{}.name'.format(category[0])]
            }

            for case in sorted(template['summary'][category[0].lower()], key=lambda k: k['min_count'], reverse=True):
                if category[1]['1'] >= case['min_count']:
                    report['summary'][category[0]] = case['message']
                    break

            for case in sorted(template['meaning'][category[0].lower()], key=lambda k: k['min_count'], reverse=True):
                if category[1]['1'] >= case['min_count']:
                    report['meaning'][category[0]] = case['message']
                    break

            report['advantages'][category[0]] = template['advantages'][category[0].lower()]
            report['challenges'][category[0]] = template['challenges'][category[0].lower()]
            report['how_others_see_you'][category[0]] = template['how_others_see_you'][category[0].lower()]
            report['general'][category[0]] = template['general'][category[0].lower()]

            if category[1]['1'] == 0:
                report['missing'][category[0]] = template['missing'][category[0].lower()]

            if category[1]['1'] >= 4:
                report['dominant'][category[0]] = template['dominant'][category[0].lower()]
                for behavior in template['behaviors'][category[0].lower()]:
                    if category[0].lower() not in report['behaviors']:
                        report['behaviors'][category[0]] = []
                    report['behaviors'][category[0]].append({
                        'name': behavior.capitalize(),
                        'description': template['behaviors'][category[0].lower()][behavior.lower()],
                    })
                report['next_steps'][category[0]] = template['next_steps'][category[0].lower()]

        return report
