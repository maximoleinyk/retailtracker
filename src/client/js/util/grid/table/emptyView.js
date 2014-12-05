define(function (require) {
    'use strict';

    var Marionette = require('marionette');

    return Marionette.ItemView.extend({

        template: require('hbs!./emptyView.hbs'),

        onRender: function () {
            this.$el.find('td').attr('colspan', this.options.columns.length);
        },

        templateHelpers: function () {
            return {
                text: this.options.title
            };
        }

    });

});
