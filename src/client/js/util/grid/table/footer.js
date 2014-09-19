define(function (require) {

    var EditRow = require('./rows/editRow'),
        ButtonCell = require('./cells/buttonCell'),
        ViewCell = require('./cells/viewCell');

    return EditRow.extend({

        initialize: function (options) {
            options = options || {};
            options.state = 'edit';

            this.model = new this.options.items.model({});
            EditRow.prototype.initialize.apply(this, arguments);
        },

        buildCustomCell: function (type, options) {
            if (type === 'edit') {
                return new ButtonCell(_.extend(options, {
                    action: function (e) {
                        console.log('Crate new model');
                    }
                }));
            } else {
                return new ViewCell(options);
            }
        }

    });

});
