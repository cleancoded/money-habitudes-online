app.directive('mhPageTitle', [function() {
    return {
        restrict: 'E',
        transclude: true,
        templateUrl: '/static/components/directives/page-title/page-title.html?build={0}'.format(MHO_BUILD)
    };
}]);
