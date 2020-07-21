from django.conf import settings
from django.core import mail
from django.template.loader import render_to_string
from urllib.parse import urljoin
from multiprocessing import Process
import sendgrid

from accounts.models import Account

def full_url(request, path=''):
    return urljoin('{}://{}'.format(request.scheme, request.get_host()), path)

def send_mail(request, recipient, subject, template, template_data, cc=None):
    if recipient.find('@example.') != -1 or recipient.find('@localhost') != -1:
        return

    text_message = render_to_string(
        'emails/{}.txt'.format(template),
        {
            'recipient': recipient,
            'request': request,
            'data': template_data,
        },
    )

    try:
        html_message = render_to_string(
            'emails/{}.html'.format(template),
            {
                'recipient': recipient,
                'request': request,
                'data': template_data,
            },
        )
    except:
        html_message = None

    if settings.DEBUG:
        target = send_mail_local
    else:
        target = send_mail_sendgrid

    Process(target=target, args=(recipient, subject, text_message, html_message, cc)).start()

def send_mail_local(recipient, subject, text_message, html_message=None, cc=None):
    #mail.send_mail(
    #    '{}: {}'.format(recipient, subject),
    #    text_message,
    #    settings.DEFAULT_FROM_EMAIL,
    #    ['me@drew-harris.com'],
    #)
    with open('/tmp/mh-email.txt', 'w') as f:
        f.write('To: {}\n'.format(recipient))
        f.write('CC: {}\n'.format(cc)) if cc else None
        f.write('Subject: {}\n'.format(subject))
        f.write('----------\n')
        f.write(text_message)

    if html_message:
        with open('/tmp/mh-email.html', 'w') as f:
            f.write('To: {}\n'.format(recipient))
            f.write('CC: {}\n'.format(cc)) if cc else None
            f.write('Subject: {}\n'.format(subject))
            f.write('----------\n')
            f.write(html_message)



def send_mail_sendgrid(recipient, subject, text_message, html_message=None, cc=None):
    mail_data = {
        'personalizations': [
            {
                'to': [
                    {
                        'email': recipient, # ensure exception if user was deleted
                    }
                ],
                'subject': subject,
            },
        ],
        'from': {
            'name': settings.DEFAULT_FROM_EMAIL_NAME,
            'email': settings.DEFAULT_FROM_EMAIL,
        },
        'content': [
            {
                'type': 'text/plain',
                'value': text_message,
            },
        ],
    }

    if html_message:
        mail_data['content'].append({
            'type': 'text/html',
            'value': html_message,
        })

    try:
        recipient_obj = Account.objects.get(email=recipient)
        mail_data['personalizations'][0]['to'][0]['name'] = recipient_obj.name
    except:
        pass

    if cc:
        mail_data['personalizations'][0]['cc'] = [{'email': cc}]

    sg = sendgrid.SendGridAPIClient(settings.SENDGRID_API_KEY)
    response = sg.client.mail.send.post(request_body=mail_data)

    return response
