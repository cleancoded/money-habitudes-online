app.config(function($stateProvider) {
    $stateProvider.state('pricing', {
        url: '/pricing',
        resolve: standardResolve,
        templateUrl: '/static/components/states/pricing/pricing.html?build={0}'.format(MHO_BUILD)
    });
});
