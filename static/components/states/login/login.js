app.config(function($stateProvider) {
    $stateProvider.state('login', {
        url: '/login',
        resolve: requireLogoutResolve,
        params: {next: 'dashboard', nextParams: {}, branding: null},
        templateUrl: '/static/components/states/login/login.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $state, $timeout, UserService, MessageService, LanguageService) {
            $scope.next = $state.params.next;
            $scope.nextParams = $state.params.nextParams;
            $scope.branding = $state.params.branding;
            $scope.login_params = {
                'email': '',
                'password': ''
            };
            $scope.show_password = false;

            $scope.login = function(email, password) {
                UserService.login(email, password).then(
                    function(me) {
                        var msg = '';
                        if ($state.params.next === 'subscription') {
                            msg = LanguageService.gettext('web.s.login.purchase');
                        }
                        $state.go($state.params.next, $state.params.nextParams).then(function() {
                            MessageService.success('web.s.login.success');
                        });
                    },
                    function(error) {
                        console.log(error);
                        if (error.status === 401 || error.status === 400) {
                            MessageService.danger('web.s.login.fail');
                        }
                        else {
                            MessageService.danger('web.error.generic');
                        }
                    }
                );
            };

            function resizeToggleButton() {
                var pbox = $('#password');
                var toggle = $('#password-toggle');

                $('#password-toggle').height($('#password').height() - 2);
            }
            $timeout(resizeToggleButton, 100);
        }
    });
});
