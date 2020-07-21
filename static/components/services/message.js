app.service('MessageService', ['$q', '$timeout', 'LanguageService', function($q, $timeout, LanguageService) {
    var idCounter = 0;
    var alerts = {};
    var listener = $q.defer();

    this.success = function(message, duration) {
        duration = typeof duration !== 'undefined' ? duration : 5000;
        create('success', message, duration);
    };

    this.info = function(message) {
        create('info', message, 2000);
    };

    this.warning = function(message) {
        create('warning', message, 2000);
    };

    // Danger persists only until next state change
    this.danger = function(message) {
        create('danger', message);
    };

    // Clears state-based messages and returns everything else
    this.refresh = function() {
        clearAll();
        return alerts;
    };

    this.listen = function() {
        return listener.promise;
    };

    this.clear = function(id) {
        clear(id);
    };

    function clearAll() {
        var keys = Object.keys(alerts);
        for (var i = 0; i < keys.length; ++i) {
            if (!alerts[keys[i]].persist) {
                clear(keys[i]);
            }
        };
    };

    function clear(id) {
        delete alerts[id];
        notify();
    }

    function notify() {
        listener.notify(alerts);
    }

    function create(type, message, duration) {
        /* Valid types are:
           - success
           - info
           - warning
           - danger
        */

        message = LanguageService.gettext(message);

        if (exists(type, message)) {return;}

        var delay = 500;
        duration = typeof duration !== 'undefined' ? duration : 0;

        id = 'a' + (idCounter++).toString();
        alerts[id] = {
            id: id,
            type: type,
            message: message,
            persist: duration > 0 ? true : false
        };

        if (duration > 0) {
            $timeout(function() {clear(id);}, duration);
        }

        notify();
    };

    function exists(type, message) {
        var keys = Object.keys(alerts);
        for (var i = 0; i < keys.length; ++i) {
            if (
                alerts[keys[i]].message === message &&
                    alerts[keys[i]].type === type
            ) {
                return true;
            }
        }

        return false;
    }
}]);
