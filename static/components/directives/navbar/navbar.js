app.directive('mhNavbar', [function() {
    return {
        restrict: 'E',
        templateUrl: '/static/components/directives/navbar/navbar.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $state, LanguageService) {
            $scope.start_game = function(share_code) {
                $state.go('codes', {code: share_code});
            };

            $scope.on_start = $state.is('start');

            $scope.mid_signup = false;
            if ($state.params.next === 'codes' || $state.$current.name === 'codes') {
                $scope.mid_signup = true;
            }

            $scope.scrollTo = function(id) {
                $('html, body').animate({
                    scrollTop: $(id).offset().top
                }, 800);
            };


            $scope.change_language = function(language) {
                LanguageService.change_language(language).then(
                    function(success) {
                        get_language_name();
                        return;
                    },
                    function(error) {
                        MessageService.danger('web.error.generic');
                    }
                );
            };

            function get_language_name() {
                for (i = 0; i < $scope.me.language_choices.length; ++i) {
                    if ($scope.me.language_choices[i][0] == $scope.me.language) {
                        $scope.language_name = $scope.me.language_choices[i][1];
                        return;
                    }
                }
            }
            get_language_name();
        }
    };
}]);
