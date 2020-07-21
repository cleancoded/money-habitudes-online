app.directive('mhBase', [function() {
    return {
        restrict: 'E',
        transclude: true,
        templateUrl: '/static/components/directives/base/base.html?build={0}'.format(MHO_BUILD)
    };
}]);
