define(function (require) {

    var Marionette = require('marionette'),
        _ = require('underscore');

    return Marionette.ItemView.extend({
        template: require('hbs!./headerCell')
    });

});