app.config(function($stateProvider) {
    $stateProvider.state('subscription', {
        url: '/subscription?product&option&group&report&siteb&reportb',
        params: {unsubscribe: {value:false, dynamic: true}},
        resolve: standardResolve,
        templateUrl: '/static/components/states/subscription/subscription.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $state, $stateParams, $location, $cookies, $uibModal, OrderService, UserService, MessageService, LanguageService) {
            var confirm_change_modal;
            var cancel_modal;
            $scope.csrftoken = $cookies.get('csrftoken');
            $scope.order_url = api_root + 'subscriptions/';
            $scope.individual_url = api_root + 'orders/';
            if ($scope.me.subscription) {
                s = $scope.me.subscription.plan_id.split('_');
                $scope.product_select = s[1];
                if (s[2] === 'pro') {
                    $scope.option_select = 'professional';
                }
                else if (s[2] === 'prem') {
                    $scope.option_select = 'premium';
                }
                else if (s[2] === 'proplus') {
                    $scope.option_select = 'proplus';
                }

                $scope.group_codes_option = $scope.me.group_codes;
                $scope.professional_report_option = $scope.me.admin_reports;
                $scope.site_branding_option = false;
                $scope.report_branding_option = false;
            }
            else {
                $scope.option_select = 'professional';
                $scope.product_select = 'monthly';
                $scope.group_codes_option = false;
                $scope.professional_report_option = false;
                $scope.site_branding_option = false;
                $scope.report_branding_option = false;
            }

            $scope.option_select = typeof $stateParams.option !== 'undefined' ? $stateParams.option : $scope.option_select;
            $scope.product_select = typeof $stateParams.product !== 'undefined' ? $stateParams.product : $scope.product_select;
            $scope.group_codes_option = typeof $stateParams.group !== 'undefined' ? $stateParams.group === 'true' : $scope.group_codes_option;
            $scope.professional_report_option = typeof $stateParams.report !== 'undefined' ? $stateParams.report === 'true' : $scope.professional_report_option;
            $scope.site_branding_option = typeof $stateParams.siteb !== 'undefined' ? $stateParams.siteb === 'true' : $scope.site_branding_option;
            $scope.report_branding_option = typeof $stateParams.reportb !== 'undefined' ? $stateParams.reportb === 'true' : $scope.report_branding_option;

            OrderService.shop().then(function(shoppingList) {
                $scope.plans = shoppingList.plans;
                $scope.products = shoppingList.products;
                $scope.loaded = true;
                $scope.calc_price();
                if ($scope.me.subscription) {
                    $scope.current_plan = searchAll($scope.me.subscription.plan_id);
                }
            });

            function searchAll(id) {
                for (i = 0; i < $scope.plans.length; ++i) {
                    if ($scope.plans[i].id === id) {
                        return $scope.plans[i];
                    }
                }

                for (i = 0; i < $scope.products.length; ++i) {
                    if ($scope.products[i].id === id) {
                        return $scope.products[i];
                    }
                }

                return null;
            }

            $scope.change_subscription = function(plan_id) {
                $scope.working = true;
                OrderService.change_subscription($scope.me.subscription.id, plan_id).then(
                    function(success) {
                        UserService.getMe(true);
                        $scope.working = false;
                        $state.go('dashboard');
                        MessageService.success('web.s.subscription.change_success');
                    }, function(error) {
                        MessageService.error('web.error.generic');
                        $scope.working = false;
                    }
                );
            };

            $scope.buy = function(id, qty) {
                if ($scope.me.logged_in) {
                    OrderService.checkout(id, qty).then(function(order) {
                        $state.go('confirm', {order_id: order.id});
                    });
                }
                else {
                    if (!$scope.me.logged_in) {
                        MessageService.info('web.error.login_required');
                        $state.go('login', {next: 'confirm'});
                    }
                }
            };

            $scope.calc_price = function(product, option, group, report, brand_site, brand_report) {
                $scope.product_select = typeof product !== 'undefined' ? product : $scope.product_select;
                $scope.option_select = typeof option !== 'undefined' ? option : $scope.option_select;
                $scope.group_codes_option = typeof group !== 'undefined' ? group : $scope.group_codes_option;
                $scope.professional_report_option = typeof report !== 'undefined' ? report : $scope.professional_report_option;
                $scope.site_branding_option = typeof brand_site !== 'undefined' ? brand_site : $scope.site_branding_option;
                $scope.report_branding_option = typeof brand_report !== 'undefined' ? brand_report : $scope.report_branding_option;

                $scope.order_string = 'mh';

                if ($scope.option_select === 'individual') {
                    $scope.order_string += '_individual';
                    $scope.plan = searchAll($scope.order_string);
                    $scope.product = $scope.plan;
                    $scope.grand_total = $scope.plan.price;
                    return;
                }
                else if ($scope.product_select === 'monthly') {
                    $scope.order_string += '_monthly';
                    $scope.interval = 'month';
                    if ($scope.option_select === 'professional') {
                        $scope.order_string += '_pro';
                        $scope.core_plan = searchAll($scope.order_string);
                        if ($scope.group_codes_option) {
                            $scope.order_string += '_group';
                        }
                        if ($scope.professional_report_option) {
                            $scope.order_string += '_report';
                        }
                    }
                    else if ($scope.option_select === 'proplus') {
                        $scope.order_string += '_proplus';
                        $scope.core_plan = searchAll($scope.order_string);
                        if ($scope.professional_report_option) {
                            $scope.order_string += '_report';
                        }
                    }
                    else if ($scope.option_select === 'premium') {
                        $scope.order_string += '_prem';
                        $scope.core_plan = searchAll($scope.order_string);
                    }
                }
                else if ($scope.product_select === 'yearly') {
                    $scope.order_string += '_yearly';
                    $scope.interval = 'year';
                    if ($scope.option_select === 'professional') {
                        $scope.order_string += '_pro';
                        $scope.core_plan = searchAll($scope.order_string);
                        if ($scope.group_codes_option) {
                            $scope.order_string += '_group';
                        }
                        if ($scope.professional_report_option) {
                            $scope.order_string += '_report';
                        }
                    }
                    else if ($scope.option_select === 'proplus') {
                        $scope.order_string += '_proplus';
                        $scope.core_plan = searchAll($scope.order_string);
                        if ($scope.professional_report_option) {
                            $scope.order_string += '_report';
                        }
                    }
                    else if ($scope.option_select === 'premium') {
                        $scope.order_string += '_prem';
                        $scope.core_plan = searchAll($scope.order_string);
                    }
                }
                $scope.plan = searchAll($scope.order_string);

                $scope.branding_total_int = 0;
                if ($scope.me.subscription && $scope.me.subscription.active) {
                    $scope.grand_total_int = 0;
                }
                else {
                    $scope.grand_total_int = $scope.plan.amount;
                }
                if ($scope.site_branding_option) {
                    $scope.branding_total_int += searchAll('site_branding').amount;
                }
                if ($scope.report_branding_option) {
                    $scope.branding_total_int += searchAll('report_branding').amount;
                }

                $scope.grand_total_int += $scope.branding_total_int;

                if ($scope.branding_total_int) {
                    $scope.branding_total = '$' + $scope.branding_total_int / 100 + '.00';
                }
                else {
                    $scope.branding_total = '-';
                }
                $scope.grand_total = '$' + $scope.grand_total_int / 100 + '.00';

                $location.search({product: $scope.product_select, option: $scope.option_select});

                $scope.grand_total_text = LanguageService.gettext('web.s.subscription.branding.total', [$scope.grand_total]);
            };

            $scope.reload = function() {
                window.location.reload();
            };

            $scope.unsubscribe = function() {
                var unsubscribeModal = $modal.open({
                    templateUrl: '/static/directives/confirm_unsubscribe.html?build={0}'.format(MHO_BUILD),
                    controller: function($scope, $state) {
                        $scope.unsubscribe = function() {
                            $scope.working = true;
                            unsubscribeModal.close();
                            OrderService.unsubscribe($scope.me.subscription.id).then(
                                function(success) {
                                    UserService.getMe(true);
                                    $scope.working = false;
                                    MessageService.success('web.s.subscription.unsubscribe_success');
                                    $state.go('dashboard');
                                },
                                function(error) {
                                    $scope.working = false;
                                    MessageService.error('web.error.generic', [error.status, error.data]);
                                }
                            );
                        };

                        $scope.cancel_unsubscribe = function() {
                            unsubscribeModal.close();
                        };
                    }
                });
            };

            $scope.do_checkout = function(token) {
                $scope.working = true;
                OrderService.checkout(token, $scope.order_string, $scope.site_branding_option, $scope.report_branding_option).then(
                    function(success) {
                        MessageService.success('web.s.subscription.purchase_success');
                        UserService.getMe(true);
                        $scope.working = false;
                        $state.go('dashboard');
                    },
                    function(error) {
                        console.log(error);
                        MessageService.danger('web.error.generic');
                        $scope.working = false;
                    }
                );
            };

            $scope.do_branding_checkout = function(token) {
                $scope.working = true;
                OrderService.checkout(token, 'branding_only', $scope.site_branding_option, $scope.report_branding_option).then(
                    function(success) {
                        MessageService.success('web.s.subscription.purchase_success');
                        $scope.working = false;
                        UserService.getMe(true);
                        confirm_change_modal.close();
                        $state.go('dashboard');
                    },
                    function(error) {
                        console.log(error);
                        MessageService.danger('web.error.generic');
                        $scope.working = false;
                    }
                );
            };

            $scope.open_confirm_change_modal = function() {
                confirm_change_modal = $uibModal.open({
                    animation: true,
                    ariaLabelBy: 'confirm_change_modal_title',
                    ariaDescribedBy: 'confirm_change_modal_body',
                    templateUrl: '/static/components/states/subscription/confirm-change-modal.html?build={0}'.format(MHO_BUILD),
                    scope: $scope
                });

                confirm_change_modal.result.then(
                    function() {
                    },
                    function() {
                    }
                );
            };

            $scope.close_confirm_change_modal = function() {
                confirm_change_modal.close();
            };

            $scope.open_cancel_modal = function() {
                cancel_modal = $uibModal.open({
                    animation: true,
                    ariaLabelBy: 'cancel_modal_title',
                    ariaDescribedBy: 'cancel_modal_body',
                    templateUrl: '/static/components/states/subscription/cancel-modal.html?build={0}'.format(MHO_BUILD),
                    scope: $scope
                });

                cancel_modal.result.then(
                    function() {
                    },
                    function() {
                    }
                );
            };

            $scope.close_cancel_modal = function() {
                cancel_modal.close();
            };

            $scope.unsubscribe = function() {
                $scope.working = true;
                OrderService.unsubscribe($scope.me.subscription.id).then(
                    function(success) {
                        UserService.getMe(true);
                        $scope.working = false;
                        $state.go('dashboard');
                        MessageService.success('web.s.subscription.unsubscribe_success');
                        cancel_modal.close();
                    },
                    function(error) {
                        MessageService.danger('web.error.generic');
                        console.log(error);
                        cancel_modal.close();
                        $scope.working = false;
                    }
                );
            };

            $scope.change_subscription = function(plan_id) {
                $scope.working = true;
                OrderService.change_subscription($scope.me.subscription.id, plan_id).then(
                    function(success) {
                        UserService.getMe(true).then(
                            function(success) {
                                $scope.working = false;
                                $scope.me = success;
                                if ($scope.site_branding_option || $scope.report_branding_option) {
                                }
                                else {
                                    MessageService.success('web.s.subscription.change_success');
                                    confirm_change_modal.close();
                                    $state.go('dashboard');
                                }
                            },
                            function(error) {
                                $scope.working = false;
                                MessageService.danger('web.error.generic');
                                console.log(error);
                            }
                        );
                    }, function(error) {
                        MessageService.danger('web.error.generic');
                        console.log(error);
                        $scope.working = false;
                    }
                );
            };

            if ($stateParams.unsubscribe) {
                $scope.open_cancel_modal();
                $state.go('.', {unsubscribe: false});
            }
        }
    });
});
