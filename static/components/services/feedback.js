app.service('FeedbackService', ['$q', '$http', function($q, $http) {
    this.send_feedback = function(name, email, message, trial, org_name, phone) {
        var deferred = $q.defer();

        $http.post(api_root + 'feedback/', {
            'name': name,
            'email': email,
            'message': message,
            'trial': trial,
            'org_name': org_name,
            'phone': phone
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
}]);
