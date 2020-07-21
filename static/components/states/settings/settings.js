app.config(function($stateProvider) {
    $stateProvider.state('settings', {
        url: '/settings?page',
        params: {create_codes: {value: false, dynamic: true}},
        resolve: requireLoginResolve,
        templateUrl: '/static/components/states/settings/settings.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $stateParams, UserService, MessageService) {
            $scope.open_modal_on_start = $stateParams.create_codes;
            if ($stateParams.page === 'general') {
                $scope.settings_page = 'general';
            }
            else if ($stateParams.page === 'codes') {
                $scope.settings_page = 'codes';
            }
            else if ($stateParams.page === 'branding') {
                $scope.settings_page = 'branding';
            }
            else {
                $scope.settings_page = 'general';
            }

            if ($scope.settings_page !== 'codes') {
                $scope.border_line_style = {'border-bottom': 'none'};
            }
            else {
                $scope.border_line_style = {};
            }
        }
    });
});
