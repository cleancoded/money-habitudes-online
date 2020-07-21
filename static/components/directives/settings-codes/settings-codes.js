app.directive('mhSettingsCodes', [function() {
    return {
        restrict: 'E',
        templateUrl: '/static/components/directives/settings-codes/settings-codes.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $state, $stateParams, $timeout, $location, $uibModal, ShareService, UserService, MessageService, LanguageService) {
            var create_code_modal = null;
            var share_detail_modal = null;
            $scope.processed_emails = [];
            $scope.code_quantity = 1;
            $scope.code_name = '';
            $scope.raw_emails = '';
            $scope.order_by = '-created_date';
            $scope.filter_by = '';
            $scope.current_page = 1;
            $scope.show_share_name_edit = false;

            $scope.get_shares = function(order_by) {
                if (order_by) {
                    if (order_by === $scope.order_by) {
                        order_by = '-' + order_by;
                    }
                    $scope.order_by = order_by;
                }

                ShareService.get_shares($scope.order_by, $scope.filter_by, $scope.current_page).then(
                    function(shares) {
                        $scope.shares = shares;
                    },
                    function(error) {
                        MessageService.danger('web.error.generic');
                        console.log(error);
                    }
                );
            };
            $scope.get_shares();

            $scope.open_create_code_modal = function() {
                $scope.codes_available = LanguageService.gettext('web.d.settings_codes.available', [$scope.me.available_games]);
                create_code_modal = $uibModal.open({
                    animation: true,
                    ariaLabelBy: 'create_code_modal_title',
                    ariaDescribedBy: 'create_code_modal_body',
                    size: 'lg',
                    templateUrl: '/static/components/directives/settings-codes/create-code-modal.html?build={0}'.format(MHO_BUILD),
                    scope: $scope
                });

                // Handles modal closure
                create_code_modal.result.then(
                    function() {
                    },
                    function() {
                    }
                );
            };

            $scope.open_share_detail_modal = function(share) {
                $scope.share_detail = share;
                $scope.share_detail_count = share.total;
                $scope.share_detail_max = share.total + $scope.me.available_games;
                $scope.share_detail_url = $location.protocol() + '://' + $location.host();
                if ( ($location.protocol() === 'http' && $location.port() !== 80) || ($location.protocol() === 'https' && $location.port() !== 443) ) {
                    $scope.share_detail_url += ':' + $location.port();
                }
                $scope.share_detail_url += '/#/codes/' + $scope.share_detail.code;
                share_detail_modal = $uibModal.open({
                    animation: true,
                    ariaLabelBy: 'share_detail_modal_title',
                    ariaDescribedBy: 'share_detail_modal_body',
                    templateUrl: '/static/components/directives/settings-codes/share-detail-modal.html?build={0}'.format(MHO_BUILD),
                    scope: $scope
                });

                // Handles modal closure
                share_detail_modal.result.then(
                    function() {
                    },
                    function() {
                    }
                );
            };

            $scope.close_share_detail_modal = function() {
                $scope.show_share_name_edit = false;
                share_detail_modal.close();
            };

            $scope.update_share_total = function(share_code, qty) {
                ShareService.change_share(share_code, qty).then(
                    function(success) {
                        UserService.getMe(true);
                        share_detail_modal.close();
                        $state.reload();
                    },
                    function(error) {
                        MessageService.danger('web.error.generic');
                        console.log(error);
                    }
                );
            };

            $scope.extract_emails = function(text) {
                var re = /(([^<>()[\]\\.,;:\s@\"\']+(\.[^<>()[\]\\.,;:\s@\"\']+)*)|(\".+\")|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))/g;

                $scope.processed_emails = text.match(re);
            };

            $scope.email_codes = function() {
                ShareService.create_share_email($scope.processed_emails).then(
                    function(success) {
                        UserService.getMe(true);
                        $state.reload();
                        create_code_modal.close();
                        MessageService.success('web.d.settings_codes.email_success');
                    }, function(error) {
                        UserService.getMe(true);
                        $state.reload();
                        create_code_modal.close();
                        MessageService.danger('web.error.generic');
                        console.log(error);
                    }
                );
            };

            $scope.group_codes = function(quantity, name) {
                ShareService.create_share_code(quantity, name).then(
                    function(success) {
                        UserService.getMe(true).then(
                            function(me) {
                                $scope.me = me;
                            }
                        );
                        create_code_modal.close();
                        $scope.open_share_detail_modal(success);
                        $scope.get_shares();
                        MessageService.success('web.d.settings_codes.group_success');
                    }, function(error) {
                        UserService.getMe(true);
                        $state.reload();
                        create_code_modal.close();
                        MessageService.danger('web.error.generic');
                        console.log(error);
                    }
                );
            };

            $scope.play_game = function() {
                ShareService.create_share_code(1, $scope.me.email).then(
                    function(share) {
                        UserService.getMe(true);
                        $state.go('codes', {code: share.code});
                        create_code_modal.close();
                    },
                    function(error) {
                        UserService.getMe(true);
                        $state.reload();
                        create_code_modal.close();
                        MessageService.danger('web.error.generic');
                        console.log(error);
                    }
                );
            };

            $scope.filter_change = function() {
                $timeout.cancel($scope.filterChangeTimeout);
                $scope.filterChangeTimeout = $timeout(function() {
                    $scope.get_shares();
                }, 500);
            };

            $scope.edit_share_name = function() {
                $scope.share_detail.edit_name = $scope.share_detail.name;
                $scope.show_share_name_edit = true;
            };

            $scope.save_share_name = function() {
                ShareService.rename_share($scope.share_detail.code, $scope.share_detail.edit_name); // Success/fail silently.
                $scope.share_detail.name = $scope.share_detail.edit_name;
                $scope.show_share_name_edit = false;
            };

            if ($scope.open_modal_on_start) {
                $scope.open_create_code_modal();
                $scope.open_modal_on_start = false;
                $state.go('.', {create_codes: false});
            }
        }
    };
}]);
