define(function (require) {

    var Row = require('./row');

    return Row.extend({

        initialize: function (options) {
            options = options || {};
            options.editable = true;

            Row.prototype.initialize.apply(this, arguments);
            this.model = new this.options.items.model({});
        }

    });

});
