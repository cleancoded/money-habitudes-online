from django.conf.urls import url, include
from rest_framework.urlpatterns import format_suffix_patterns

from api_beta import views

urlpatterns = [
    url(r'^$', views.ApiRoot.as_view(), name='api_root'),
    url(r'^auth/login/$', views.Login.as_view(), name='login'),
    url(r'^auth/logout/$', views.Logout.as_view(), name='logout'),
    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    url(r'^me/$', views.Me.as_view(), name='me'),
    url(r'^me/email/confirm/$', views.MeSendConfirm.as_view(), name='me_send_confirm'),
    url(r'^me/email/(?P<pk>[0-9a-f-]+)/$', views.MeConfirm.as_view(), name='me_confirm'),
    url(r'^me/password/$', views.ChangePassword.as_view(), name='change_password'),
    url(r'^me/branding/$', views.AdminBranding.as_view(), name='admin_branding'),
    url(r'^products/$', views.Products.as_view(), name='products'),
    url(r'^products/(?P<pk>[0-9a-f-]+)/$', views.ProductDetail.as_view(), name='product_detail'),
    url(r'^games/$', views.Games.as_view(), name='games'),
    url(r'^games/latest/$', views.Games.last_played, name='last_played_game'),
    url(r'^games/(?P<pk>[0-9a-f-]+)/$', views.GameDetail.as_view(), name='game_detail'),
    url(r'^shares/$', views.Shares.as_view(), name='shares'),
    url(r'^subscriptions/$', views.Subscriptions.as_view(), name='subscriptions'),
    url(r'^subscriptions/(?P<pk>[0-9a-f-]+)/$', views.SubscriptionDetail.as_view(), name='subscription_detail'),
    url(r'^subscriptions/payment_info/$', views.SubscriptionPaymentInfo.as_view(), name='subscription_payment_info'),
    url(r'^orders/$', views.Orders.as_view(), name='orders'),
    url(r'^shares/(?P<code>[0-9a-zA-Z]+)/$', views.ShareDetail.as_view(), name='share_detail'),
    url(r'^feedback/$', views.Feedback.as_view(), name='feedback'),
    url(r'^language/$', views.Language.as_view(), name='language'),
]

urlpatterns = format_suffix_patterns(urlpatterns)
