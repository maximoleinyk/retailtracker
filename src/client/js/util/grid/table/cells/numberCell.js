define(function (require) {

    var ViewCell = require('./viewCell');

    return ViewCell.extend({

        template: require('hbs!./numberCell'),

        ui: {
            $input: 'input'
        },

        events: {
            'change @ui.$input': 'updateModel'
        },

        updateModel: function () {
            var property = this.options.column.get('field'),
                value = this.ui.$input.val();

            this.model.set(property, value);
        },

        activate: function () {
            var self = this;

            setTimeout(function () {
                self.ui.$input.focus().select();
            }, 0);
        },

        appendValue: function (value) {
            this.ui.$input.val(value);
        }

    });

});
