app.directive('mhUsageVideo', [function() {
    return {
        restrict: 'E',
        template: '<div class="embed-responsive embed-responsive-16by9"><iframe id="demoVideo" class="embed-responsive-item"  src="https://www.youtube.com/embed/UkIoJi03Sro?rel=0&autoplay=1" frameborder="0" gesture="media" allowfullscreen></iframe></div>'
    };
}]);
