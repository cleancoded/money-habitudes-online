app.directive('mhPricingTable', [function() {
    return {
        restrict: 'E',
        templateUrl: '/static/components/directives/pricing-table/pricing-table.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $window) {
            function bind_height() {
                var rows = [
                    'row1',
                    'row2',
                    'row3',
                    'row4',
                    'row5',
                    'row6',
                    'row7'
                ];

                for (var i = 0; i < rows.length; ++i) {
                    var elems = $('[data-mh="' + rows[i] + '"]');
                    elems.each(function() {
                        $(this).height('');
                    });
                    var heights = elems.toArray().map(function(elem) { return $(elem).height(); });
                    elems.each(function () {
                        $(this).height(Math.max.apply(Math, heights));
                    });
                }
            }

            bind_height();
            angular.element($window).bind('resize', function() {
                bind_height();
            });
        }
    };
}]);
