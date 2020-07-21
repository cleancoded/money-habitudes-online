from datetime import timedelta
import csv

from games.models import Game

activity_per_day = [['Date', 'Games started', 'Total games started']]
activity_per_month = [['Month', 'Games started', 'Total games started']]
activity_per_year = [['Year', 'Games started', 'Total games started']]

starting_date = Game.objects.order_by('created_date').first().created_date.date()
ending_date = Game.objects.order_by('created_date').last().created_date.date()
delta = timedelta(days=1)

game_total = 0
month_tracker = [starting_date.isoformat()[:7], 0, 0]
year_tracker = [starting_date.isoformat()[:4], 0, 0]

while starting_date <= ending_date:
    date = starting_date.isoformat()
    month = starting_date.isoformat()[:7]
    year = starting_date.isoformat()[:4]

    games_started_today = Game.objects.filter(created_date__date=starting_date.isoformat()).count()

    if month_tracker[0] != month:
        activity_per_month.append(month_tracker)
        month_tracker = [month, 0, 0]
    
    if year_tracker[0] != year:
        activity_per_year.append(year_tracker)
        year_tracker = [year, 0, 0]

    game_total += games_started_today

    activity_per_day.append([date, games_started_today, game_total])
    month_tracker[1] += games_started_today
    month_tracker[2] = game_total
    year_tracker[1] += games_started_today
    year_tracker[2] = game_total

    starting_date += delta

activity_per_month.append(month_tracker)
activity_per_year.append(year_tracker)


with open('/tmp/activity_per_day.csv', 'w', newline='', encoding='utf8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerows(activity_per_day)
with open('/tmp/activity_per_month.csv', 'w', newline='', encoding='utf8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerows(activity_per_month)
with open('/tmp/activity_per_year.csv', 'w', newline='', encoding='utf8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerows(activity_per_year)