app.directive('mhSettingsBranding', [function() {
    return {
        restrict: 'E',
        templateUrl: '/static/components/directives/settings-branding/settings-branding.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $state, $cookies, UserService, MessageService) {
            $scope.csrftoken = $cookies.get('csrftoken');
            $scope.branding_root = api_root + 'me/branding/';

            $scope.loadBranding = function() {
                UserService.get_branding().then(
                    function(success) {
                        $scope.branding = success;
                        if ($scope.branding.cover_text) {
                            $scope.branding.cover_text = $scope.branding.cover_text.join('\n');
                        }

                        $scope.delete_image = false;
                    },
                    function(error) {
                        MessageService.danger('web.error.generic');
                        console.log(error);
                    }
                );
            };
            $scope.loadBranding();
        }
    };
}]);
