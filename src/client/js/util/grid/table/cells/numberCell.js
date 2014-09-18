define(function (require) {

    var InputCell = require('./inputCell');

    return InputCell.extend({

        getName: function() {
            return this.options.column.get('field');
        }

    });

});
