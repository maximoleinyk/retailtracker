define(function (require) {

    var AbstractCell = require('./abstractCell');

    return AbstractCell.extend({

        template: require('hbs!./buttonCell'),

        templateHelpers: function() {
            return {
                label: _.bind(this.getLabel, this)
            }
        },

        getLabel: function () {
            return 'Click';
        },

        action: function(e) {
            this.options.action(e);
        }

    });

});
