app.service('OrderService', ['$q', '$http', function($q, $http) {
    this.list_subscriptions = function() {
        var deferred = $q.defer();

        $http.get(api_root + 'subscriptions/').then(
            function(success) {
                deferred.resolve(success.data);
            },
            function(error) {
                deferred.reject(error.data);
            }
        );

        return deferred.promise;
    };

    this.get_subscription = function(subscription_id) {
        var deferred = $q.defer();

        $http.get(api_root + 'subscritions/{0}'.format(subscription_id)).then(
            function(success) {
                deferred.resolve(success.data);
            },
            function(error) {
                deferred.reject(error.data);
            }
        );

        return deferred.promise;
    };

    this.change_subscription = function(subscription_id, plan_id) {
        var deferred = $q.defer();

        $http.put(api_root + 'subscriptions/{0}/'.format(subscription_id), {'plan_id': plan_id}).then(
            function(success) {
                deferred.resolve(success.data);
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.unsubscribe = function(subscription_id) {
        var deferred = $q.defer();

        $http.delete(api_root + 'subscriptions/{0}/'.format(subscription_id)).then(
            function(success) {
                deferred.resolve(success.data);
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.checkout = function(token, order_id, siteb, reportb) {
        var deferred = $q.defer();

        $http.post(api_root + 'orders/', {
            token: token,
            order_id: order_id,
            site_branding: siteb,
            report_branding: reportb
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

    this.shop = function() {
        var deferred = $q.defer();

        $http.get(api_root + 'products/').then(
            function(success) {
                deferred.resolve(success.data);
            },
            function(error) {
                deferred.reject(error.data);
            }
        );

        return deferred.promise;
    };

    this.order_history = function() {
        var deferred = $q.defer();

        $http.get(api_root + 'orders/').then(
            function (success) {
                deferred.resolve(success.data);
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };
}]);
