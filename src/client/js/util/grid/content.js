define(function (require) {

    var Marionette = require('marionette'),
        Row = require('./row');

    return Marionette.CollectionView.extend({

        template: require('hbs!./content'),
        itemView: true,

        buildItemView: function(model) {
            return new Row({
                model: model,
                columns: this.options.columns
            });
        }

    });
});
