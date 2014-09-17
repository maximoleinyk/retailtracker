define(function (require) {

    var Marionette = require('marionette'),
        _ = require('underscore');

    return Marionette.ItemView.extend({

        template: require('hbs!./viewCell'),
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

        renderValue: function() {
            var value = this.model.get(this.options.column.get('field')),
                formatter = this.options.column.get('formatter');

            if (_.isFunction(formatter)) {
                value = formatter(value, this.model);
            }

            this.appendValue(value);
        },

        appendValue: function(value) {
            this.$el.text(value);
        }

    });

});
