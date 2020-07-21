app.service('GameService', ['$q', '$http', function($q, $http) {
    var game = null;

    this.get_history = function(order_by, filter_by, page) {
        url = api_root + 'games/';
        if (order_by || filter_by || page) {
            url += '?';
        }
        if (order_by) {
            url += 'order_by={0}'.format(order_by);
        }
        if (order_by && filter_by) {
            url += '&';
        }
        if (filter_by) {
            url += 'filter_by={0}'.format(filter_by);
        }

        if (page) {
            if (order_by || filter_by) {
                url += '&';
            }

            url += 'page={0}'.format(page);
        }


        var deferred = $q.defer();

        $http.get(url).then(
            function(success) {
                deferred.resolve(success.data);
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.get_game = function(game_id) {
        game = null;
        var deferred = $q.defer();

        $http.get(api_root + 'games/{0}/'.format(game_id)).then(
            function(success) {
                game = success.data;
                deferred.resolve(game);
            },
            function(error) {
                game = null;
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.latest_game = function() {
        game = nul;
        var deferred = $q.defer();

        $http.get(api_root + 'games/latest/').then(
            function(success) {
                game = success.data;
                if (game) {
                    deferred.resolve(game);
                }
                else {
                    deferred.resolve(false);
                }
            });

        return deferred.promise;
    };

    this.answer = function(card, answer) {
        var deferred = $q.defer();

        $http.post(api_root + 'games/{0}/'.format(game.id), {
            card_id: card.id,
            answer: answer
        }).then(
            function(success) {
                game.answers.push(answer);
                deferred.resolve();
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.undo = function() {
        var deferred = $q.defer();

        $http.delete(api_root + 'games/{0}/'.format(game.id), {}).then(
            function(success) {
                game.answers.pop();
                deferred.resolve();
            },
            function(error) {
                deferred.reject(error.data);
            }
        );

        return deferred.promise;
    };

    this.remind = function(game_id) {
        var deferred = $q.defer();

        $http.put(api_root + 'games/{0}/'.format(game_id), {
            'remind': true
        }).then(
            function(success) {
                deferred.resolve();
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.revoke = function(game_id) {
        var deferred = $q.defer();

        $http.put(api_root + 'games/{0}/'.format(game_id), {
            'revoke': true
        }).then(
            function(success) {
                deferred.resolve();
            },
            function(error) {
                deferred.reject(error);
            }
        );

        return deferred.promise;
    };

    this.next_cards = function() {
        cardset_index = 0;
        cardset = [];
        start = game.answers.length;
        end = game.cards.length;
        for (var i = start; i < end; ++i) {
            card = game.cards[i];
            cardset[cardset_index] = get_card_data(card);
            cardset_index += 1;
            if (cardset.length === 4) {
                return angular.copy(cardset);
            }
        }

        return cardset;
    };

    function get_card_data(card_id) {
        for (var i = 0; i < game.cardset_data.cards.length; ++i) {
            if (game.cardset_data.cards[i].id === card_id) {
                return game.cardset_data.cards[i];
            }
        }

        return {};
    }

    function get_answered_card(card_id) {
        for (var i = 0; game.answered_cards &&  i < game.answered_cards.length; ++i) {
            if (game.answered_cards[i] === card_id) {
                return i;
            }
        }

        return -1;
    }
}]);
