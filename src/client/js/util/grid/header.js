define(function (require) {

    var Backbone = require('backbone'),
        Marionette = require('marionette'),
        HeaderCell = require('./headerCell'),
        _ = require('underscore');

    return Marionette.CollectionView.extend({

        template: require('hbs!./header'),
        itemView: HeaderCell,

        initialize: function () {
            this.collection = new Backbone.Collection(_.map(this.options.columns, function (value, key) {
                return _.extend(value, {
                    field: key
                });
            }));
        }

    });

});
