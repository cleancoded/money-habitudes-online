app.config(function($stateProvider) {
    $stateProvider.state('logout', {
        url: '/logout',
        resolve: angular.extend({}, requireLoginResolve, {
            logout: function($state, UserService) {
                return UserService.logout().then(function() {
                    if ($state.current.name === 'start') {
                        $state.reload();
                    }
                    else {
                        $state.go('start');
                    }
                });
            }
        })
    });
});
