define(function (require) {

    var Backbone = require('backbone'),
        Marionette = require('marionette'),
        HeaderCell = require('./cells/headerCell'),
        _ = require('underscore');

    return Marionette.CollectionView.extend({

        template: require('hbs!./header'),
        itemView: HeaderCell,
        tagName: 'tr',

        initialize: function () {
            this.collection = new Backbone.Collection(this.options.columns);
        }

    });

});
