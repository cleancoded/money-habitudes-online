app.directive('mhBanner', [function() {
    return {
        restrict: 'E',
        templateUrl: '/static/components/directives/banner/banner.html?build={0}'.format(MHO_BUILD),
        controller: function($scope, $uibModal) {
            var demo_video_modal = null;

            $scope.open_demo_video_modal = function() {
                demo_video_modal = $uibModal.open({
                    animation: true,
                    ariaLabelBy: 'demo_video_modal_title',
                    ariaDescribedBy: 'demo_video_modal_body',
                    templateUrl: '/static/components/directives/banner/demo-video.html?build={0}'.format(MHO_BUILD),
                    scope: $scope,
                    size: 'lg'
                });

                demo_video_modal.result.then(
                    function() {
                    },
                    function() {
                    }
                );
            };

            $scope.close_demo_video_modal = function() {
                demo_video_modal.close();
            };

            $scope.scrollTo = function(id) {
                $('html, body').animate({
                    scrollTop: $(id).offset().top
                }, 800);
            };
        }
    };
}]);
