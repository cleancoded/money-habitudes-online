app.config(function($stateProvider) {
    $stateProvider.state('dashboard', {
        url: '/dashboard',
        resolve: requireLoginResolve,
        templateUrl: '/static/components/states/dashboard/dashboard.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $state, UserService, MessageService) {
        }
    });
});
