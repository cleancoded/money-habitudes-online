from django import template
register = template.Library()

from accounts.models import Account

@register.simple_tag
def is_admin_report(user):
	a = Account.objects.filter(email=user.email)
	if len(a) > 0:
		return 1 if a[0].admin_report_override == True else 0
	return 0
