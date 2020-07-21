from django.contrib.postgres.fields import JSONField
from django.db import models
from django.utils import timezone
from django.utils.text import slugify
import json
import uuid

from cards.cardset import Cardset

class Game(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4)
    created_date = models.DateTimeField(auto_now_add=True)
    modified_date = models.DateTimeField(auto_now=True)

    cardset = models.CharField(max_length=16, default='adult')
    data = JSONField(default=dict)
    owner = models.ForeignKey('accounts.Account', on_delete=models.CASCADE, related_name='owned_games')
    player = models.ForeignKey('accounts.Account', on_delete=models.CASCADE, related_name='played_games')
    player_name = models.CharField(max_length=64)
    player_email = models.CharField(max_length=255)
    share = models.ForeignKey('accounts.Share', on_delete=models.CASCADE, related_name='games')
    share_name = models.CharField(max_length=64)
    last_activity_date = models.DateTimeField(auto_now_add=True)
    completed = models.BooleanField(default=False)

    """
    Answer the next card.

    :value: Answer as integer value
    """
    def answer(self, value):
        data = self.data
        if len(data['answers']) != len(data['cards']):
            data['answers'].append(value)
            self.data = data
            self.last_activity_date = timezone.now()
            self.save()

        return data

    def undo(self):
        data = self.data
        if len(data['answers']) and self.completed == False:
            data['answers'].pop()
            self.data = data
            self.last_activity_date = timezone.now()
            self.save()

        return data

    def finalize(self):
        data = self.data
        if len(data['answers']) != len(data['cards']):
            return

        cardset = Cardset.get_cardset(self.cardset)
        data = cardset.game_results(data)
        self.completed = True

        self.data = data
        self.last_activity_date = timezone.now()
        self.save()

        return data

    def pdf_url(self):
        return '/reports/{0}/{1}.pdf'.format(str(self.id), slugify('{0} {1}'.format(timezone.now().date().isoformat(), self.player.name)))

    def professional_url(self):
        return '/reports/{0}/{1}-professional.pdf'.format(str(self.id), slugify('{0} {1}'.format(timezone.now().date().isoformat(), self.player.name)))

    @classmethod
    def start_game(Game, cardset, share, player):
        if player.played_games.filter(share=share).exists():
            game = player.played_games.filter(share=share).latest('created_date')

        else:
            if share.total - share.used > 0 or not share.owner.enforce_limits:
                game = Game.objects.create(
                    cardset = cardset.id,
                    data = cardset.game_template,
                    owner = share.owner,
                    player = player,
                    player_name = player.name,
                    player_email = player.email,
                    share = share,
                    share_name = share.name,
                )

                if game.player.id == game.owner.id and game.share.total == 1:
                    game.share.individual = True
                    game.share.save()
            else:
                return None

            share.used += 1
            share.save()

        return game
