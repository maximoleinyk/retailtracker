define(function (require) {

    var Row = require('./row');

    return Row.extend({

        initialize: function (options) {
            options = options || {};
            options.state = 'edit';

            this.model = new this.options.items.model({});
            Row.prototype.initialize.apply(this, arguments);
        }

    });

});
