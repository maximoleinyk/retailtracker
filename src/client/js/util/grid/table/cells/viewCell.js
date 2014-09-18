define(function (require) {

    var AbstractCell = require('./abstractCell'),
        _ = require('underscore');

    return AbstractCell.extend({

        template: require('hbs!./viewCell'),

        appendValue: function(value) {
            this.$el.text(value);
        }

    });

});
