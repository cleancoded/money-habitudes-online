from django.http import JsonResponse, HttpResponseRedirect
from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt

from language import pick_language

def index(request, language=''):
    user_agent = request.META.get('HTTP_USER_AGENT', '').lower()
    if 'trident' in user_agent or 'msie' in user_agent:
        request.is_IE = True
    else:
        request.is_IE = False

    request.language = pick_language(request, language)

    return render(request, 'index.html')

def home(request):
    return HttpResponseRedirect('/')
    #return render(request, 'home.html')

def pricing(request):
    return HttpResponseRedirect('/#/pricing')
    #return render(request, 'pricing.html')

@csrf_exempt
def mirror(request):
    response = {
        'scheme': request.scheme,
        'path': request.path,
        'path_info': request.path_info,
        'method': request.method,
        'encoding': request.encoding,
        'content_type': request.content_type,
        'content_params': request.content_params,
        'get': request.GET.dict(),
        'cookies': request.COOKIES,
    }

    if request.method == 'POST' or request.method == 'PUT':
        response['post'] = request.POST.dict()

    return JsonResponse(response, json_dumps_params={'indent':4, 'sort_keys': True})
