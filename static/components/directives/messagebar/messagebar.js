app.directive('mhMessagebar', [function() {
    return {
        restrict: 'E',
        templateUrl: '/static/components/directives/messagebar/messagebar.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, MessageService) {
            $scope.alerts = MessageService.refresh();
            MessageService.listen().then(null, null, function(alerts) {
                $scope.alerts = alerts;
            });

            $scope.closeAlert = function(id) {
                MessageService.clear(id);
            };
        }
    };
}]);
