define(function (require) {

    var Marionette = require('marionette');

    return Marionette.ItemView.extend({

        tagName: 'td',

        initialize: function() {
            var field = this.options.column.get('field');

            switch (field) {
                case 'numerable':
                case 'editable':
                    break;
                default:
                    this.model.on('change:' + field, _.bind(this.renderValue, this));
                    break;
            }
        },

        onRender: function() {
            this.renderValue();
        },

        renderValue: function() {
            var value = this.model.get(this.options.column.get('field')),
                formatter = this.options.column.get('formatter');

            if (_.isFunction(formatter)) {
                value = formatter(value, this.model);
            }

            this.appendValue(value);
        },

        appendValue: function(value) {
            // abstract method
        },

        nextCell: function() {
            var nextCell = this.options.cellManager.next(this.options.column);

            if (nextCell) {
                nextCell.activate();
            }
        },

        activate: function () {
            // abstract method
        }

    });

});
