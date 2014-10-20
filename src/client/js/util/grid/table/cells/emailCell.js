define(function (require) {

    var InputCell = require('./inputCell');

    return InputCell.extend({

        getType: function () {
            return 'email';
        }

    });

});
