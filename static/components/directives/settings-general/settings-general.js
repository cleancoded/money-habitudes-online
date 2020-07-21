app.directive('mhSettingsGeneral', [function() {
    return {
        restrict: 'E',
        templateUrl: '/static/components/directives/settings-general/settings-general.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $state, UserService, OrderService, MessageService, LanguageService) {
            $scope.change_name = $scope.me.name;
            $scope.change_email = $scope.me.email;
            $scope.original_password = '';
            $scope.new_password = '';
            $scope.confirm_password = '';
            $scope.language = $scope.me.language;

            $scope.change_language = function() {
                LanguageService.change_language($scope.language).then(
                    function(success) {
                        return;
                    },
                    function(error) {
                        MessageService.danger('web.error.generic');
                    }
                );
            };

            $scope.submit_changes = function() {
                var name = null;
                var email = null;
                var language = null;
                var original_password = null;
                var new_password = null;
                var confirm_password = null;
                var info_change = false;

                if ($scope.change_name !== $scope.me.name) {
                    name = $scope.change_name;
                    info_change = true;
                }
                if ($scope.change_email !== $scope.me.email) {
                    email = $scope.change_email;
                    info_change = true;
                }

                if ($scope.language !== $scope.me.language) {
                    language = $scope.language;
                    info_change = true;
                }

                if (info_change) {
                    UserService.setMe(name, email, language).then(
                        function(success) {
                            MessageService.success('web.d.settings_general.update_success');
                        },
                        function(error) {
                            MessageService.danger('web.error.generic');
                        }
                    );
                }

                if ($scope.new_password !== '') {
                    if ($scope.new_password !== $scope.confirm_password) {
                        MessageService.danger('web.d.settings_general.password_fail');
                    }
                    else {
                        UserService.change_password($scope.original_password, $scope.new_password).then(
                            function(success) {
                                MessageService.success('web.d.settings_general.change_success');
                                UserService.getMe(true);
                                $state.reload();
                            },
                            function(error) {
                                MessageService.danger('web.error.generic');
                                console.log(error);
                            }
                        );
                    }
                }
            };

            $scope.change_payment = function(token) {
                OrderService.checkout(token, 'cc_change').then(
                    function(success) {
                        MessageService.success('web.d.settings_general.credit_success');
                        UserService.getMe(true);
                        $state.reload();
                    },
                    function(error) {
                        MessageService.danger('web.error.generic');
                        console.log(error);
                    }
                );
            };
        }
    };
}]);
