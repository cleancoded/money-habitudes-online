app.directive('mhGameHistoryTable', [function() {
    return {
        restrict: 'E',
        templateUrl: '/static/components/directives/game-history-table/game-history-table.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $state, $timeout, $uibModal, UserService, GameService, MessageService) {
            var game_detail_modal = null;
            $scope.game_history = null;
            $scope.order_by = '-last_activity_date';
            $scope.fitler_by = '';
            $scope.current_page = 1;

            $scope.get_history = function(order_by) {
                if (order_by) {
                    if (order_by === $scope.order_by) {
                        order_by = '-' + order_by;
                    }
                    $scope.order_by = order_by;
                }

                GameService.get_history($scope.order_by, $scope.filter_by, $scope.current_page).then(
                    function(game_history) {
                        $scope.game_history = game_history;
                        if (!$scope.show_game_history) {
                            $scope.show_game_history = game_history.count > 0 && (game_history.count > 1 || game_history[0].player.id !== me.id);
                        }
                    }
                );
            };
            $scope.get_history();

            $scope.filter_change = function() {
                $timeout.cancel($scope.filterChangeTimeout);
                $scope.filterChangeTimeout = $timeout(function() {
                    $scope.get_history();
                }, 500);
            };

            $scope.open_detail = function(game) {
                $scope.game_detail = game;
                game_detail_modal = $uibModal.open({
                    animation: true,
                    ariaLabelBy: 'game_detail_modal_title',
                    ariaDescribedBy: 'game_detail_modal_body',
                    templateUrl: '/static/components/directives/game-history-table/game-detail-modal.html?build={0}'.format(MHO_BUILD),
                    scope: $scope
                });

                // Handles modal closure
                game_detail_modal.result.then(
                    function() {
                    },
                    function() {
                    }
                );
            };

            $scope.open_report = function(path) {
                $state.go('load', {path: path});
                game_detail_modal.close();
            };

            $scope.open_quick_report = function(game_id) {
                $state.go('games', {game_id: game_id});
                game_detail_modal.close();
            };

            $scope.continue_playing = function(game) {
                $state.go('play', {game_id: game.id});
                game_detail_modal.close();
            };

            $scope.close_detail = function() {
                game_detail_modal.close();
            };

            $scope.revoke = function(game_id) {
                GameService.revoke(game_id).then(
                    function(success) {
                        UserService.getMe(true);
                        $state.reload();
                        MessageService.success('web.d.ght.delete_success');
                        game_detail_modal.close();
                    },
                    function(error) {
                        MessageService.danger('web.error.generic');
                        game_detail_modal.close();
                        console.log(error);
                    }
                );
            };

            $scope.remind = function(game_id) {
                GameService.remind(game_id).then(
                    function(success) {
                        MessageService.success('web.d.ght.reminder_success', 2000);
                        game_detail_modal.close();
                    },
                    function(error) {
                        MessageService.danger('web.error.generic');
                        game_detail_modal.close();
                        console.log(error);
                    }
                );
            };
        }
    };
}]);
