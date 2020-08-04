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
                        $scope.language_name = get_language_name();
                        return;
                    },
                    function(error) {
                        MessageService.danger('web.error.generic');
                    }
                );
            };

            $scope.get_language_name = function() {
                var language = null;
                for (i = 0; i < $scope.me.language_choices.length; ++i) {
                    if ($scope.me.language_choices[i][0] == $scope.me.language) {
                        language = $scope.me.language_choices[i][1]
                        break;
                    }
                }

                return language == null ? 'English' : language
            }
        }
    };
}]);
