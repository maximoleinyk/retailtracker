define(function (require) {
    'use strict';

    var InputCell = require('./inputCell');

    return InputCell.extend({

        getType: function () {
            return 'email';
        }

    });

});
