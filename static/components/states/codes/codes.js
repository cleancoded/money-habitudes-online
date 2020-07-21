app.config(function($stateProvider) {
    $stateProvider.state('codes', {
        url: '/codes/{code}',
        resolve: angular.extend({}, standardResolve, {
            code: function($stateParams, $state, $rootScope, UserService, ShareService, MessageService) {
                $rootScope.code = $stateParams.code;
                $rootScope.name = '';

                return UserService.getMe().then(function(me) {
                    if ($rootScope.code !== 'preview') {
                        return ShareService.get_share($rootScope.code).then(
                            function(share) {
                                var branding = typeof share.branding !== 'undefined' ? share.branding: null;
                                if (!me.logged_in && !share.anonymous) {
                                    $state.go('signup', {next: 'codes', nextParams: {code: $rootScope.code}, branding: branding});
                                    return null;
                                }
                                $rootScope.share = share;
                                return null;
                            },
                            function(error) {
                                MessageService.danger('web.error.generic');
                                console.log(error);
                            }
                        );
                    }
                    else {
                        UserService.get_branding().then(
                            function(success) {
                                $rootScope.share = {
                                    anonymous: false,
                                    available: true,
                                    claimed: false,
                                    branding: success
                                };
                            }
                        );
                        return null;
                    }
                });
            }
        }),
        templateUrl: '/static/components/states/codes/codes.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $state, $stateParams, UserService, ShareService, MessageService, OrderService, LanguageService) {
            $scope.payment_processing = false;
            $scope.language = $scope.me.language;

            $scope.change_language = function(language) {
                LanguageService.change_language(language).then(
                    function(success) {
                        return;
                    },
                    function(error) {
                        MessageService.danger('web.error.generic');
                    }
                );
            };

            $scope.claim_share = function(name) {
                ShareService.claim_share($scope.share.code, name).then(
                    function(game) {
                        if ($scope.share.anonymous) {
                            UserService.getMe(true);
                        }
                        $state.go('games', {game_id: game.id});
                    },
                    function(error) {
                        MessageService.danger('web.error.generic');
                        console.log(error);
                    }
                );
            };

            $scope.do_checkout = function(token) {
                $scope.payment_processing = true;
                OrderService.checkout(token, 'mh_ptp', false, false).then(
                    function(success) {
                        $scope.claim_share();
                    },
                    function(error) {
                        $scope.payment_processing = false;
                        MessageService.danger('web.error.generic');
                        console.log(error);
                    }
                );
            };

            $scope.change_account = function() {
                UserService.logout().then(
                    function() {
                        $state.reload();
                    }
                );
            };

            /*
            if ($scope.code !== 'preview') {
                ShareService.get_share($scope.code).then(
                    function(share) {
                        var branding = typeof share.branding !== 'undefined' ? share.branding: null;
                        if (!$scope.me.logged_in && !share.anonymous) {
                            $state.go('signup', {next: 'codes', nextParams: {code: $scope.code}, branding: branding});
                        }
                        $scope.share = share;
                    },
                    function(error) {
                        console.log(error);
                    }
                );
            }
            else {
                $scope.share = {
                    anonymous: false,
                    available: true,
                    claimed: false,
                    branding: $scope.me.branding
                };
            }*/
        }
    });
});
