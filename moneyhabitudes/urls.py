"""moneyhabitudes URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.10/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf.urls import url, include
from . import views
from reports.views import PdfReport, CoverSample, ProfessionalReport
from accounts.views import ValidateShare

urlpatterns = [
    url(r'^$', views.index),
    url(r'^(?P<language>[a-z]{2}_[A-Z]{2})/$', views.index),
    url(r'^home/$', views.home),
    url(r'^pricing/$', views.pricing),
    url(r'^mirror/$', views.mirror),
    url(r'^api/beta/', include('api_beta.urls')),
    url(r'^admin/', include('admin.urls')),
    url(r'^reports/cover_sample.pdf', CoverSample.as_view(), name='cover_sample'),
    url(r'^reports/(?P<pk>[0-9a-f-]+)/(?P<filename>[\x20-\x7E]+)-professional.pdf', ProfessionalReport.as_view(), name='professional_report'),
    url(r'^reports/(?P<pk>[0-9a-f-]+)/(?P<filename>[\x20-\x7E]+).pdf', PdfReport.as_view(), name='pdf_report'),
    url(r'^share/(?P<pk>[0-9a-f-]+)/$', ValidateShare.as_view(), name='share'),
]
