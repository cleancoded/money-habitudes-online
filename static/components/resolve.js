var standardResolve = null;
var requireLoginResolve = null;
var requireLogoutResolve = null;

app.config(function() {
    standardResolve = {
        init: function($rootScope, $state, UserService) {
            return UserService.getMe().then(function(me) {
                $rootScope.me = me;
                return null;
            });
        },
        PreviousState: function($state) {
            return {
                name: $state.current.name,
                params: $state.params,
                url: $state.href($state.current.name, $state.params)
            };
        }
    };

    requireLoginResolve = angular.extend({}, standardResolve, {
        validation: function($state, UserService, MessageService) {
            return UserService.getMe().then(function(me) {
                if (!me.logged_in) {
                    var next = $state.current.name;
                    if (next === 'login' || next === 'signup') {
                        next = 'dashboard';
                    }
                    $state.go('login', {next: next}).then(function() {
                        MessageService.danger('web.error.login_required');
                    });
                }
            });
        }
    });

    requireLogoutResolve = angular.extend({}, standardResolve, {
        validation: function($state, UserService, MessageService, PreviousState) {
            return UserService.getMe().then(function(me) {
                if (me.logged_in) {
                    $state.go(PreviousState.name, PreviousState.params).then(function() {
                        MessageService.danger('web.error.login_already');
                    });
                }
            });
        }
    });
});
