app.directive('mhFooter', [function() {
    return {
        restrict: 'E',
        templateUrl: '/static/components/directives/footer/footer.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, LanguageService) {
            $scope.copyright = LanguageService.gettext('web.d.footer.copyright', [(new Date()).getFullYear()]);
        }
    };
}]);
