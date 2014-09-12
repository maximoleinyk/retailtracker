define(function (require) {

    var Marionette = require('marionette');

    return Marionette.ItemView.extend({

        template: require('hbs!./numberCell'),

        initialize: function() {}

    });

});
