app.service('ShareService', ['$q', '$http', function($q, $http) {
    this.get_shares = function(order_by, filter_by, page) {
        url = api_root + 'shares/';
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

        if (page) {
            if (order_by || filter_by) {
                url += '&';
            }

            url += 'page={0}'.format(page);
        }

        var deferred = $q.defer();

        $http.get(url).then(
            function(success) {
                deferred.resolve(success.data);
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.get_share = function(share_code) {
        var deferred = $q.defer();

        $http.get(api_root + 'shares/{0}/'.format(share_code)).then(
            function(success) {
                deferred.resolve(success.data);
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.claim_share = function(share_code, name) {
        var deferred = $q.defer();

        $http.post(api_root + 'shares/{0}/'.format(share_code), {
            name: name
        }).then(
            function(success) {
                deferred.resolve(success.data);
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.create_share_code = function(quantity, name) {
        var deferred = $q.defer();

        $http.post(api_root + 'shares/', {
            quantity: quantity,
            name: name
        }).then(
            function(success) {
                deferred.resolve(success.data);
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.create_share_email = function(emails) {
        var deferred = $q.defer();

        $http.post(api_root + 'shares/', {
            emails: emails,
            quantity: emails.length
        }).then(
            function(success) {
                deferred.resolve(success.data);
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.rename_share = function(share_code, name) {
        var deferred = $q.defer();

        $http.put(api_root + 'shares/{0}/'.format(share_code), {
            name: name
        }).then(
            function(success) {
                deferred.resolve(success.data);
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.change_share = function(share_code, qty) {
        var deferred = $q.defer();

        $http.put(api_root + 'shares/{0}/'.format(share_code), {
            new_total: qty
        }).then(
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
