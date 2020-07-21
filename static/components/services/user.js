app.service('UserService', ['$q', '$http', function($q, $http) {
    var me = null;
    var deferredMe = null;

    this.getMe = function(refresh) {
        refresh = typeof refresh !== 'undefined' ? refresh : false;

        if (refresh) {
            me = null;
            deferredMe = null;
        }

        if (deferredMe) {
            return deferredMe.promise;
        }
        else {
            deferredMe = $q.defer();
        }

        $http.get(api_root + 'me/').then(
            function(success) {
                if (success.data.email && success.data.email.endsWith('@localhost')) {
                    success.data.email = '';
                }
                me = success.data;
                deferredMe.resolve(me);
            }
        );

        return deferredMe.promise;
    };

    this.login = function(email, password) {
        var deferred = $q.defer();

        $http.post(api_root + 'auth/login/', {
            email: email,
            password: password
        }).then(
            function(success) {
                me = success.data;
                deferredMe = deferred;
                deferred.resolve(me);
            },
            function(error) {
                me = null;
                deferredMe = null;
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.signup = function(email, password, name, language) {
        name = typeof name !== 'undefined' ? name : '';

        var deferred = $q.defer();

        $http.post(api_root + 'me/', {
            email: email,
            password: password,
            name: name,
            language: language
        }).then(
            function(success) {
                me = success.data;
                deferredMe = deferred;
                deferred.resolve(me);
            },
            function(error) {
                me = null;
                deferredMe = null;
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.logout = function() {
        var deferred = $q.defer();

        if (me && me.logged_in) {
            $http.post(api_root + 'auth/logout/', {}).then(
                function(success) {
                    me = null;
                    deferredMe = null;
                    deferred.resolve();
                },
                function(error) {
                    deferred.reject(error);
                }
            );
        }
        else {
            deferred.reject({
                code: 400,
                data: "Not logged in."
            });
        }

        return deferred.promise;
    };

    this.reconfirm_email = function() {
        var deferred = $q.defer();

        $http.post(api_root + 'me/email/confirm/', {}).then(
            function(success) {
                deferred.resolve();
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.setMe = function(name, email, language) {
        name = typeof name !== null ? name : false;
        email = typeof email !== null ? email: false;
        language = typeof language !== null ? language: false;

        var deferred = $q.defer();

        body = {};
        if (name) {
            body['name'] = name;
        }
        if (email) {
            body['email'] = email;
        }

        if (language) {
            body['language'] = language;
        }

        $http.put(api_root + 'me/', body).then(
            function(success) {
                me = null;
                deferredMe = null;
                deferred.resolve();
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.get_history = function(order_by, filter_by) {
        url = api_root + 'games/';
        if (order_by || filter_by) {
            url += '?';
        }
        if (order_by) {
            url += 'order_by={0}'.format(order_by);
        }
        if (order_by && filter_by) {
            url += '&';
        }
        if (filter_by) {
            url += 'filter_by={0}'.format(filter_by);
        }

        var deferred = $q.defer();

        $http.get(url).then(
            function(success) {
                deferred.resolve(success.data);
            },
            function(error) {
                deferred.reject(error.data);
            }
        );

        return deferred.promise;
    };

    this.confirm_email = function(confirmation) {
        var deferred = $q.defer();

        $http.post(api_root + 'me/email/{0}/'.format(confirmation), {}).then(
            function(success) {
                deferred.resolve();
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.delete_me = function() {
        var deferred = $q.defer();

        $http.delete(api_root + 'me/').then(

            function(success) {
                deferred.resolve();
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.change_password = function(current_password, password) {
        var deferred = $q.defer();

        $http.post(api_root + 'me/password/', {
            current_password: current_password,
            password: password
        }).then(
            function(success) {
                deferred.resolve();
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.forgot_password = function(email) {
        var deferred = $q.defer();

        $http.post(api_root + 'me/password/', {
            email: email,
            forgot: true
        }).then(
            function(success) {
                deferred.resolve();
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.change_forgotten_password = function(email, token, password) {
        var deferred = $q.defer();

        $http.post(api_root + 'me/password/', {
            email: email,
            password_reset_token: token,
            password: password
        }).then(
            function(success) {
                deferred.resolve();
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.get_branding = function() {
        var deferred = $q.defer();

        $http.get(api_root + 'me/branding/').then(
            function(success) {
                deferred.resolve(success.data);
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };
}]);
