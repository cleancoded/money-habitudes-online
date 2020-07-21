var app = angular.module('MoneyHabitudesApp', [
    'ngAnimate',
    'ui.router',
    'ui.bootstrap',
    'ui.grid',
    'chart.js',
    'ngCookies',
    'stripe.checkout'
]);

var api_root = '/api/beta/';

var colorPalette = {
    Carefree: '#d9a300',
    Giving: '#00b200',
    Planning: '#2693ff',
    Security: '#aaaaaa',
    Spontaneous: '#ff4000',
    Status: '#c926ff'
};

app.config(function($httpProvider, $urlRouterProvider, $locationProvider, $qProvider) {
    $httpProvider.defaults.xsrfCookieName = 'csrftoken';
    $httpProvider.defaults.xsrfHeaderName = 'X-CSRFToken';

    $urlRouterProvider.otherwise('/');

    $locationProvider.hashPrefix('');

    $qProvider.errorOnUnhandledRejections(false);
});

app.directive('markdown', function() {
    var converter = new showdown.Converter();
    var link = function(scope, element, attrs, model) {
        var render = function() {
            var htmlText = converter.makeHtml(model.$modelValue);
            element.html(htmlText);
        };
        if (attrs.ngModel) {
            scope.$watch(attrs['ngModel'], render);
            render();
        }
        else {
            var htmlText = converter.makeHtml(element.text());
            element.html(htmlText);
        }
    };
    return {
        restrict: 'E',
        require: 'ngModel',
        link: link
    };
});

app.filter('format', ['LanguageService', function(LanguageService) {
    return function(input) {
        var args = Array.from(arguments);
        return LanguageService.gettext(args[0], args.slice(1));
    };
}]);

app.run(['$rootScope', function ($rootScope, $anchorScroll) {
    //create a new instance
    new WOW().init();

    $rootScope.STRIPE_PUBLISHABLE_KEY = STRIPE_PUBLISHABLE_KEY;
    $rootScope.t = STRINGS;

    $rootScope.$on('$stateChangeStart', function (next, current) {
        //when the view changes sync wow
        new WOW().sync();
    });

    $rootScope.$on('$locationChangeStart', function() {
        document.body.scrollTop = document.documentElement.scrollTop = 0;
    });

    if (window.location.hostname.match('online.moneyhabitudes.com')) {
        window.ga('create', 'UA-3814463-1', 'auto');
        $rootScope.$on('$locationChangeSuccess', function (event) {
            window.ga('send', 'pageview', window.location.pathname + window.location.hash);
        });
    }
}]);
