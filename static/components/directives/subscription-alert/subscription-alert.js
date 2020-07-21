app.directive('mhSubscriptionAlert', [function() {
    return {
        restrict: 'E',
        templateUrl: '/static/components/directives/subscription-alert/subscription-alert.html?build={0}'.format(MHO_BUILD),
        controller: function() {
        }
    };
}]);
