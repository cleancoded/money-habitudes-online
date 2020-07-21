app.config(function($stateProvider) {
    $stateProvider.state('password', {
        url: '/password/?token&email',
        resolve: standardResolve,
        templateUrl: '/static/components/states/password/password.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $state, $stateParams, UserService, MessageService) {
            $scope.email_sent = false;
            $scope.show_password = false;
            if ($stateParams.token) {
                $scope.token = $stateParams.token;
            }
            if ($stateParams.email) {
                $scope.email = $stateParams.email;
            }

            $scope.send_confirm_email = function(email) {
                UserService.forgot_password(email).then(
                    function(success) {
                        $scope.email_sent = true;
                    },
                    function(error) {
                        MessageService.danger("web.s.password.fail");
                        console.log(error);
                    }
                );
            };

            $scope.change_forgotten_password = function(email, password) {
                var token  = $stateParams.token;
                UserService.change_forgotten_password(email, token, password).then(
                    function(success) {
                        $state.go('login');
                        MessageService.success("web.s.password.reset.success");
                    },
                    function(error) {
                        MessageService.danger("web.s.password.reset.fail");
                        console.log(error);
                    }
                );
            };
        }
    });
});
