from collections import OrderedDict
from rest_framework.pagination import PageNumberPagination
from rest_framework.response import Response
from rest_framework.utils.urls import remove_query_param, replace_query_param

class MhPagination(PageNumberPagination):
    def get_generic_link(self):
        url = self.request.build_absolute_uri()
        page_number = ''
        return replace_query_param(url, self.page_query_param, page_number) + '{0}'

    def get_paginated_response(self, data):
        return Response(OrderedDict([
            ('count', self.page.paginator.count),
            ('next', self.get_next_link()),
            ('previous', self.get_previous_link()),
            ('link', self.get_generic_link()),
            ('results', data),
        ]))
