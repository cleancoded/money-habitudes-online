# Generated by Django 3.0.6 on 2020-05-08 11:03

import django.contrib.postgres.fields.jsonb
from django.db import migrations, models
import django.db.models.deletion
import uuid


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('accounts', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Game',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, primary_key=True, serialize=False)),
                ('created_date', models.DateTimeField(auto_now_add=True)),
                ('modified_date', models.DateTimeField(auto_now=True)),
                ('cardset', models.CharField(default='adult', max_length=16)),
                ('data', django.contrib.postgres.fields.jsonb.JSONField(default=dict)),
                ('player_name', models.CharField(max_length=64)),
                ('player_email', models.CharField(max_length=255)),
                ('share_name', models.CharField(max_length=64)),
                ('last_activity_date', models.DateTimeField(auto_now_add=True)),
                ('completed', models.BooleanField(default=False)),
                ('owner', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='owned_games', to='accounts.Account')),
                ('player', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='played_games', to='accounts.Account')),
                ('share', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='games', to='accounts.Share')),
            ],
        ),
    ]
