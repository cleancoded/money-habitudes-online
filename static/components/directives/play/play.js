app.directive('mhPlay', [function($timeout, GameService) {
    return {
        restrict: 'E',
        templateUrl: '/static/components/directives/play/play.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $timeout, $state, GameService, MessageService) {
            $scope.do_animation = false;
            $scope.answer_value = null;
            $scope.freeze = false;

            $scope.answer = function(answer) {
                if ($scope.freeze) {
                    return;
                }
                $scope.freeze = true;

                $scope.answer_value = answer;
                $scope.do_animation = true;
                GameService.answer($scope.card[0], answer).then(
                    function() {
                        $scope.answer_value = null;
                        $timeout(function() {
                            calc_progress();
                            $scope.card = GameService.next_cards();
                            $scope.freeze = false;
                            $scope.do_animation = false;
                        }, 500);
                    },
                    function(error) {
                        console.log(error);
                        MessageService.danger('web.d.play.error');
                    }
                );
            };

            $scope.undo = function() {
                if ($scope.freeze || !$scope.game.answers.length) {
                    return;
                }
                $scope.freeze = true;

                process = GameService.undo().then(function(response) {
                    $scope.card = GameService.next_cards();
                    calc_progress();
                    $scope.freeze = false;
                });


            };

            $scope.view_results = function() {
                $state.reload();
            };

            function calc_progress() {
                if (!$scope.game.answers) {
                    $scope.progress = 100;
                }
                $scope.progress = 100* $scope.game.answers.length / $scope.game.cards.length;
            }
        }
    };
}]);
