define(function (require) {

    var Marionette = require('marionette'),
        ViewRow = require('./viewRow');

    return Marionette.CollectionView.extend({

        template: require('hbs!./content'),
        itemView: ViewRow,

        buildItemView: function (model, ItemView) {
            return new ItemView({
                columns: this.columns,
                model: model
            });
        }

    });
});
