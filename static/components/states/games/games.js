app.config(function($stateProvider) {
    $stateProvider.state('games', {
        url: '/games/{game_id}',
        resolve: requireLoginResolve,
        templateUrl: '/static/components/states/games/games.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $state, $stateParams, GameService, MessageService) {
            $scope.tutorial_complete = false;

            GameService.get_game($stateParams.game_id).then(
                function(game) {
                    $scope.game = game;
                    $scope.show = {
                        game: game.answers && game.answers.length > 0,
                        tutorial: game.answers && game.answers.length === 0
                    };
                    $scope.card = GameService.next_cards();
                    calc_progress();
                },
                function(error) {
                    console.log(error);
                    MessageService.danger('web.error.generic');
                }
            );

            function calc_progress() {
                if (!$scope.game.answers) {
                    $scope.progress = 100;
                    return;
                }
                $scope.progress = 100* $scope.game.answers.length / $scope.game.cards.length;
            }
        }
    });
});
