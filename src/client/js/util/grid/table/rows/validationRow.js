define(function (require) {

    var _ = require('underscore'),
        Marionette = require('marionette');

    return Marionette.ItemView.extend({

        template: require('hbs!./validationRow'),
        tagName: 'tr',

        templateHelpers: function() {
            var self = this;
            return {
                errors: function() {
                    return _.values(self.options.errors);
                }
            };
        },

        onRender: function() {
            this.options.row.children.each(function(itemView) {
                itemView.invalid();
            });
            this.$el.children().first().attr('colspan', this.options.columns.length);
        }

    });

});
