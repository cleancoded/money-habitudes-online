import random

from importlib import import_module

class Cardset:
    """
    Defines a cardset. Initialize with the cardset's id and ids of its
    categories and cards. Provides string codes for cardset objects and
    relationships between categories and cards, derived from ids.

    :name: Cardset identifier.
    :categories: List of category identifiers.
    :cards: List of card identifiers.
    """
    def __init__(self, name, categories, cards):
        """
        Initialize a cardset with its metadata
        :name: name of this cardset
        :categories: list of category ids
        :cards: list of card ids
        """
        self._name = name
        self._categories = categories
        self._cards = cards
        self._cache = {
            'cardset': {
                'id': name,
                'strings': {'name': 'cardset.{}.name'.format(name)},
            },
            'categories': {},
            'cards': {},
        }

    @property
    def id(self):
        return self._name

    @property
    def cardset(self):
        return self._cache['cardset']

    @property
    def categories(self):
        if self._cache['categories'] != {}:
            return self._cache['categories']
        else:
            return self._build_categories()

    @property
    def categories_list(self):
        return list(self.categories.values())

    @property
    def cards(self):
        if self._cache['cards'] != {}:
            return self._cache['cards']
        else:
            return self._build_cards()

    @property
    def cards_list(self):
        return list(self.cards['card'].values())

    @property
    def data(self):
        if self._cache['categories'] == {}:
            self._build_categories()
        if self._cache['cards'] == {}:
            self._build_cards()

        return self._cache

    @property
    def game_template(self):
        cards = self._cards.copy()
        random.shuffle(cards)
        return {
            'cards': cards,
            'answers': [],
        }

    def game_results(self, game_data):
        data = {
            'answers': [],
            'categories': {},
        }
        cards = self.cards

        for category in self._categories:
            data['categories'][category] = {-1: 0, 0: 0, 1: 0}

        for card_id in self._cards:
            card = cards['card'][card_id]
            answer = game_data['answers'][game_data['cards'].index(card_id)]
            data['answers'].append(answer)
            data['categories'][card['category']][answer] += 1

        data['categories'] = data['categories']

        return data

    def _build_categories(self):
        data = {}
        for category in self._categories:
            base = 'cardset.{}.category.{}.{}'.format(self._name, category, '{}')
            data[category] = {
                'id': category,
                'strings': {
                    'name': base.format('name'),
                    'description': base.format('description'),
                }
            }

        self._cache['categories'] = data
        return data

    def _build_cards(self):
        data = {
            'category': {},
            'card': {},
        }

        for category in self._categories:
            data['category'][category] = []

        for card in self._cards:
            category = self._card_category(card)
            data['category'][category].append(card)
            data['card'][card] = {
                'id': card,
                'category': category,
                'strings': {
                    'text': 'cardset.{}.card.{}{}'.format(self._name, category, card[-1])
                }
            }

        self._cache['cards'] = data
        return data

    def _card_category(self, card):
        cc = card[:2]
        for category in self._categories:
            if category.startswith(cc):
                return category

    def get_cardset(name='adult'):
        """
        Fetch a cardset definition object.

        :name: Cardset identifier
        """
        module = import_module('cards.sets.{}'.format(name))
        return module.cardset
