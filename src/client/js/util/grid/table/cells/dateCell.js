define(function (require) {

    var Marionette = require('marionette');

    return Marionette.ItemView.extend({

        template: require('hbs!./dateCell'),
        tagName: 'td',

        initialize: function() {}

    });

});
