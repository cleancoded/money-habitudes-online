var app = angular.module('MoneyHabitudesApp');

app.directive('mhPieChart', [function() {
    return {
        restrict: 'E',
        scope: {
            'data': '=',
            'size': '@',
            'resultType': '@',
            'tooltips': '@',
            'legend': '@'
        },
        template: '<div style="{{style}}"><canvas class="chart chart-pie" chart-data="values" chart-labels="labels" chart-colors="colors" chart-options="options"></canvas></div>',
        controller: function($scope, LanguageService) {
            $scope.legend = typeof $scope.legend !== 'undefined' ? eval($scope.legend) : false;
            $scope.tooltips = typeof $scope.tooltips !== 'undefined' ? eval($scope.tooltips) : true;
            $scope.style = 'width:{0};'.format($scope.size);
            $scope.$watch('data', function() {
                if ($scope.data) {
                    var labels = [];
                    var values = [];
                    var colors = [];
                    for (var key in colorPalette) {
                        labels.push(LanguageService.gettext('web.category.' + key[0].toLowerCase() + key[1]));
                        values.push(get_value(key));
                        colors.push(colorPalette[key]);
                    }
                    $scope.labels = labels;
                    $scope.values = values;
                    $scope.colors = colors;
                    $scope.options = {
                        tooltips: {
                            enabled: $scope.tooltips
                        },
                        legend: {
                            display: $scope.legend,
                            position: 'right',
                            onClick: function() {}
                        }
                    };
                }
            });

            function get_value(key) {
                whichResult = typeof $scope.resultType !== 'undefined' ? $scope.resultType : 1;
                key = key.toLowerCase().substr(0, 2);
                return $scope.data.results[key][whichResult];
            }
        }
    };
}]);
