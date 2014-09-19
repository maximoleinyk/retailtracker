define(function (require) {

    var ViewCell = require('./viewCell'),
        _ = require('underscore');

    return ViewCell.extend({

        renderValue: function() {
            this.appendValue(this.options.cellManager.getIndex() + 1);
        }

    });

});
