import json
import requests

class ApiRequests:
    def __init__(self, host_path='http://localhost:8000', api_path='/api/beta/', cookies=None, csrf=None):
        self.host_path = host_path
        self.api_path = api_path
        self.path = host_path + api_path
        self.cookies = cookies
        self.csrf = csrf

    def create_user(self, email, password='test', name=''):
        response = requests.post(
            self.path + 'me/',
            json={
                'email': email,
                'password': password,
                'name': name
            }
        )

        self.cookies = response.cookies
        return response

    def get_me(self):
        return requests.get(
            self.path + 'me/',
            cookies=self.cookies
        )

    def change_me(self, name=None, email=None):
        r= {}
        if name:
            r['name'] = name
        if email:
            r['email'] = email

        return requests.put(
            self.path + 'me/',
            json=r,
            cookies=self.cookies,
            headers={'X-CSRFToken': self.cookies.get('csrftoken')}
        )

    def login(self, email, password='test'):
        response = requests.post(
            self.path + 'auth/login/',
            json={
                'email': email,
                'password': password
            })

        self.cookies = response.cookies
        self.csrf = response
        return response

    def logout(self):
        response = requests.post(
            self.path + 'auth/logout/',
            json={},
            cookies=self.cookies,
            headers={'X-CSRFToken': self.cookies.get('csrftoken')}
        )

        self.cookies = response.cookies
        return response
