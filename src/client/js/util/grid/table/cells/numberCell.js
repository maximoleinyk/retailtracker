define(function (require) {

    var Marionette = require('marionette');

    return Marionette.ItemView.extend({

        template: require('hbs!./numberCell'),
        tagName: 'td',
        binding: true,

        templateHelpers: function() {
            var self = this;

            return {
                getField: function() {
                    return self.options.column.get('field');
                }
            }
        }

    });

});
