app.service('LanguageService', ['$q', '$http', '$rootScope', function($q, $http, $rootScope) {
    this.gettext = function(identifier) {
        path = identifier.split('.');
        s = STRINGS;
        for (i = 0; i < path.length; ++i) {
            try {
                key = path[i];
                s = s[key];
            }
            catch (e) {
                s = false;
            }
        }

        if (!s) {
            return '[' + identifier + ']';
        }

        var args = arguments;
        if (args[1] && args[1].constructor === Array) {
            return s.format(args[1]);
        }

        return s;
    };

    this.change_language = function(language) {
        var deferred = $q.defer();

        $http.post(api_root + 'language/', {
            'language': language
        }).then(
            function(success) {
                STRINGS = success.data;
                $rootScope.t = success.data;
                $rootScope.me.language = language;
                deferred.resolve();
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };
}]);
