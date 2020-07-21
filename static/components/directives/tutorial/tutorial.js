app.directive('mhTutorial', [function() {
    return {
        restrict: 'E',
        scope: {
            complete: '='
        },
        templateUrl: '/static/components/directives/tutorial/tutorial.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $rootScope) {
            $scope.page = 0;
            $scope.last_page = 3;
            $scope.t = $rootScope.t;

            $scope.complete_tutorial = function() {
                $scope.complete = true;
            };

            $scope.next = function() {
                if ($scope.page < $scope.last_page) {
                    $scope.page += 1;
                }
            };

            $scope.back = function() {
                if ($scope.page > 0) {
                    $scope.page -= 1;
                }
            };
        }
    };
}]);
