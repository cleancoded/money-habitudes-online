from django.http import HttpResponseRedirect, HttpResponseForbidden
from django.views.generic import TemplateView

from accounts.models import Share

class ValidateShare(TemplateView):
    def get(self, request, pk):
        share = Share.objects.get(pk=pk)
        if share.is_valid_referrer(request):
            request.session['valid_referrer'] = True
            request.session.set_expiry(0)
            return HttpResponseRedirect('/#/codes/{}'.format(share.code))
        else:
            return HttpResponseForbidden('{} is not a valid referrer.'.format(request.META.get('HTTP_REFERER', 'None')))
