define(function (require) {

    var AbstractCell = require('./abstractCell');

    return AbstractCell.extend({

        template: require('hbs!./inputCell'),

        ui: {
            $input: 'input'
        },

        events: {
            'change @ui.$input': 'updateModel'
        },

        templateHelpers: function() {
            return {
                type: _.bind(this.getType, this),
                name: _.bind(this.getName, this),
                placeholder: _.bind(this.getPlaceholder, this)
            }
        },

        updateModel: function () {
            var property = this.options.column.get('field'),
                value = this.ui.$input.val();

            this.model.set(property, value);
        },

        appendValue: function (value) {
            this.ui.$input.val(value);
        },

        getPlaceholder: function() {
            return '';
        },

        getName: function() {
            return this.options.column.get('field');
        },

        getType: function() {
            return 'text';
        },

        activate: function () {
            var self = this;

            setTimeout(function () {
                self.ui.$input.focus().select();
            }, 0);
        }

    });

});
