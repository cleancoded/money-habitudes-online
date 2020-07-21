app.config(function($stateProvider) {
    $stateProvider.state('load', {
        url: '/load?{path}',
        resolve: standardResolve,
        templateUrl: '/static/components/states/load/load.html?build={0}'.format(MHO_BUILD),
        controller: function($stateParams) {
            location.href = $stateParams['path'];
        }
    });
});
