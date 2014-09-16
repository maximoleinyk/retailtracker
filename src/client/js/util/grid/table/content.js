define(function (require) {

    var Marionette = require('marionette'),
        Row = require('./row');

    return Marionette.CollectionView.extend({

        template: require('hbs!./content'),
        itemView: Row,

        buildItemView: function(model, ItemView) {
            return new ItemView({
                model: model,
                columns: this.options.columns
            });
        }

    });
});
