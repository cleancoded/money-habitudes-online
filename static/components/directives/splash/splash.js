app.directive('mhSplash', [function() {
    return {
        restrict: 'E',
        templateUrl: '/static/components/directives/splash/splash.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $window, $stateParams, $timeout, FeedbackService) {
            $scope.scrollTo = function(id) {
                $('html, body').animate({
                    scrollTop: $(id).offset().top
                }, 800);
            };

            function bind_height() {
                var rows = [
                    'row1',
                    'row2',
                    'row3',
                ];

                for (var i = 0; i < rows.length; ++i) {
                    var elems = $('[data-mh="' + rows[i] + '"]');
                    elems.each(function() {
                        $(this).height('');
                    });
                    var heights = elems.toArray().map(function(elem) { return $(elem).height(); });
                    elems.each(function () {
                        $(this).height(Math.max.apply(Math, heights));
                    });
                }
            }

            bind_height();
            angular.element($window).bind('resize', function() {
                bind_height();
            });

            $timeout(function() {
                if ($stateParams.goto) {
                    $scope.scrollTo('#{0}'.format($stateParams.goto));
                }
            }, 1000);

            $scope.send_feedback = function(name, email, message, trial, org_name, phone) {
                if (!name || !email || (trial && (!org_name || !phone))) {
                    $scope.form_error = true;
                    return;
                }
                $scope.working = true;

                FeedbackService.send_feedback(name, email, message, trial, org_name, phone).then(
                    function(success) {
                        $scope.working = false;
                        $scope.sent = true;
                        $scope.scrollTo('#contact-wrap');
                    },
                    function(error) {
                        $scope.working = false;
                        console.log(error);
                    }
                );
            };
        }
    };
}]);
