app.config(function($stateProvider) {
    $stateProvider.state('signup', {
        url: '/signup',
        resolve: requireLogoutResolve,
        params: {next: 'dashboard', nextParams: {}, branding: null},
        templateUrl: '/static/components/states/signup/signup.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $state, $timeout, $sce, UserService, MessageService, LanguageService) {
            $scope.next = $state.params.next;
            $scope.nextParams = $state.params.nextParams;
            $scope.branding = $state.params.branding;
            $scope.signup_params = {
                'name': '',
                'email': '',
                'password': '',
                'language': $scope.me.language
            };
            $scope.show_password = false;

            $scope.privacy_disclaimer = $sce.trustAsHtml(LanguageService.gettext('web.s.signup.policy_disclaimer',
                                                                                 ['<a href="https://www.moneyhabitudes.com/privacy-policy/">' + LanguageService.gettext('web.s.signup.policy_name') + '</a>']));

            $scope.change_language = function() {
                LanguageService.change_language($scope.signup_params.language).then(
                    function(success) {
                        return;
                    },
                    function(error) {
                        MessageService.danger('web.error.generic');
                    }
                );
            };

            $scope.signup = function(email, password, name, language) {
                email = $scope.signup_params.email;
                password = $scope.signup_params.password;
                name = $scope.signup_params.name;
                language = $scope.signup_params.language;
                UserService.signup(email, password, name, language).then(
                    function(me) {
                        var msg = '';
                        if ($state.params.next === 'subscription') {
                            msg = ' ' + LanguageService.gettext('web.s.login.purchase');
                        }
                        $state.go($state.params.next, $state.params.nextParams).then(function() {
                            MessageService.success('web.s.login.success', 10000);
                        });
                    },
                    function(error) {
                        console.log(error);
                        if (error.status === 400) {
                            MessageService.danger('web.s.signup.fail');
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
