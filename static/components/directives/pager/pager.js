app.directive('mhPager', function() {
    return {
        restrict: 'E',
        scope: {
            'data': '=',
            'page': '='
        },
        templateUrl: '/static/components/directives/pager/pager.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, ResourceService) {
            $scope.change_page = function() {
                ResourceService.getResource($scope.data.link.format($scope.page)).then(
                    function(success) {
                        $scope.data = success;
                    },
                    function(error) {
                        console.log(error);
                    }
                );
            };
        }
    };
});
