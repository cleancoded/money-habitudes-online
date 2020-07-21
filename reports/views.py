from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import render
from django.views.decorators.cache import cache_control
from django.views.generic import TemplateView
from PyPDF2 import PdfFileReader, PdfFileMerger
import io

from games.models import Game
from reports.helpers import to_pdf, sample_cover, professional_report

class PdfReport(TemplateView):
    @cache_control(max_age=31557600)
    def get(self, request, pk, filename):
        game = Game.objects.get(pk=pk)

        pdf = to_pdf(request, game, show_next_steps = game.owner.show_next_steps)
        if game.owner.report_end:
            report_start = PdfFileReader(io.BytesIO(pdf))
            report_end = PdfFileReader(game.owner.report_end.path)
            merger = PdfFileMerger(strict=False)
            merger.append(report_start)
            merger.append(report_end)
            result = io.BytesIO()
            merger.write(result)
            pdf = result
            pdf.seek(0)

        response = HttpResponse(pdf, content_type='application/pdf')
        response['Content-Disposition'] = 'filename={0}.pdf'.format(filename)
        return response

class CoverSample(TemplateView):
    def get(self, request):
        pdf = sample_cover(request)

        response = HttpResponse(pdf, content_type='application/pdf')
        response['Content-Disposition'] = 'filename=mh_sample_cover.pdf'
        return response

class ProfessionalReport(TemplateView):
    @cache_control(max_age=31557600)
    def get(self, request, pk, filename):
        if not request.user.is_authenticated:
            return HttpResponseRedirect('/#/login')
        game = request.user.account.owned_games.get(pk=pk)
        pdf = professional_report(request, game)

        response = HttpResponse(pdf, content_type='application/pdf')
        response['Content-Disposition'] = 'filename={0}.pdf'.format(filename)
        return response
