define(function (require) {

    var Marionette = require('marionette'),
        _ = require('underscore');

    return Marionette.ItemView.extend({

        template: require('hbs!./headerCell'),
        tagName: 'th',

        onRender: function() {
            if (this.model.get('type') !== 'number') {
                return;
            }
            this.$el.addClass('numeric');
        }

    });

});
