from django.conf.urls import url

from . import views

app_name = 'admin'

urlpatterns = [
    url(r'^$', views.index),
    url(r'^accounts/$', views.account_list),
    url(r'^accounts/(?P<pk>[0-9a-f-]+)/$', views.account_detail),
    url(r'^accounts/(?P<pk>[0-9a-f-]+)/shares/$', views.account_detail_shares),
    url(r'^accounts/(?P<pk>[0-9a-f-]+)/games/$', views.account_detail_games),
    url(r'^shares/$', views.share_list),
    url(r'^shares/(?P<pk>[0-9a-f-]+)/$', views.share_detail),
    url(r'^shares/(?P<pk>[0-9a-f-]+)/games/$', views.share_detail_games),
    url(r'^games/$', views.game_list),
    url(r'^products/$', views.product_list),
    url(r'^reports/$', views.report_list),
    url(r'^reports/admin_usage/$', views.report_admin_usage),
    url(r'^reports/game_usage/$', views.report_game_usage),
    url(r'^login/$', views.login, name='login'),
    url(r'^export_games/$', views.export_game_list, name="export_games"),
]
