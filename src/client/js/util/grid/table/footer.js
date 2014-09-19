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

        renderCustomCell: function(type, options) {
            if (type === 'autoincrement') {
                return new ViewCell(options);
            }
        },

        renderButtonCell: function(options) {
            return new ButtonCell(_.extend(options, {
                action: function(e) {
                    console.log('Create new record');
                }
            }));
        }

    });

});
