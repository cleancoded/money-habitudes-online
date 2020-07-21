app.directive('mhDistributeGames', [function() {
    return {
        restrict: 'E',
        templateUrl: '/static/components/directives/distribute-games/distribute-games.html?build={0}'.format(MHO_BUILD),
        controller: function() {
        }
    };
}]);
