app.service('ResourceService', ['$q', '$http', '$timeout', function($q, $http, $timeout) {
    var cachedResources = {};
    var deferredCachedResources = {};

    this.getResource = function(url) { return getResource(url); };

    function getResource(url) {
        if (url in deferredCachedResources) {
            if (url in cachedResources) {
                deferredCachedResources[url].resolve(cachedResources[url]);
            }
            return deferredCachedResources[url].promise;
        }
        else {
            deferredCachedResources[url] = $q.defer();
            $http.get(url).then(function(response) {
                cachedResources[url] = response.data;
                deferredCachedResources[url].resolve(cachedResources[url]);
                $timeout(function() {
                    delete deferredCachedResources[url];
                    delete cachedResources[url];
                }, 60000);
            }, function(error) {
                deferredCachedResources[url].reject('NotFound');
            });
        }

        return deferredCachedResources[url].promise;
    };
}]);
