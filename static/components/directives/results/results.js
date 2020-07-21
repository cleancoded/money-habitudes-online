app.directive('mhResults', [function($timeout, GameService) {
    return {
        restrict: 'E',
        templateUrl: '/static/components/directives/results/results.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $timeout, LanguageService) {
            $scope.page = 0;
            calc_habitudes();
            $scope.last_page = 7;

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

           function calc_habitudes() {
                var thats_me_count = 0;
                var sometimes_me_count = 0;
                var never_me_count = 0;
                var dominant = [];
                var missing = [];
                var show_missing_sometimes = false;
                var show_missing_never = false;
                $scope.query_result = {};
                results_list = [];
                for (var key in $scope.game.results) {
                    results_list.push([key, $scope.game.results[key]]);
                }
                for (var i = 0; i < results_list.length; ++i) {
                    $scope.query_result[results_list[i][0]] = results_list[i][1];
                    thats_me_count += results_list[i][1][1];
                    sometimes_me_count += results_list[i][1][0];
                    never_me_count += results_list[i][1][-1];
                    if (results_list[i][1][1] >= 4) {
                        dominant.push(results_list[i][0]);
                    }
                    if (results_list[i][1][1] === 0) {
                        missing.push(results_list[i][0]);
                        if (results_list[i][1][-1] >= 7 && results_list[i][1][-1] <= 9) {
                            show_missing_never = true;
                        }
                        if (results_list[i][1][0] > 0 && results_list[i][1][0] <= 6) {
                            show_missing_sometimes = true;
                        }
                    }
                }
                $scope.dominant = dominant;
                $scope.missing = missing;
                $scope.thats_me_count = thats_me_count;
                $scope.sometimes_me_count = sometimes_me_count;
                $scope.never_me_count = never_me_count;
                $scope.show_missing_never = show_missing_never;
                $scope.show_missing_sometimes = show_missing_sometimes;
               $scope.cardfour = LanguageService.gettext('web.d.results.card4', [$scope.thats_me_count]);
            };
        }
    };
}]);
