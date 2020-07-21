app.config(function($stateProvider) {
    $stateProvider.state('start', {
        url: '/?goto',
        resolve: standardResolve,
        templateUrl: '/static/components/states/start/start.html?build={0}'.format(MHO_BUILD)
    });
});
