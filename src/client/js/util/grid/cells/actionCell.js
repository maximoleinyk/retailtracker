define(function (require) {

    var Marionette = require('marionette');

    return Marionette.ItemView.extend({

        template: require('hbs!./actionCell'),

        action: function(e) {
            e.preventDefault();

            console.log(this.model.toJSON());
        }

    });

});
