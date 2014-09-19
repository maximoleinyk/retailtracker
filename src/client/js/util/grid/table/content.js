define(function (require) {

    var Marionette = require('marionette'),
        EditRow = require('./rows/editRow'),
        ViewRow = require('./rows/viewRow');

    return Marionette.CollectionView.extend({

        template: require('hbs!./content'),
        itemView: true,

        // @Override
        renderItemView: function(view, index) {
            view.render(index);
            this.appendHtml(this, view, index);
        },

        buildItemView: function(model) {
            var ItemView;

            if (this.options.state === 'view') {
                ItemView = ViewRow;
            } else if (this.options.state === 'edit') {
                ItemView = EditRow;
            } else {
                throw 'Unknown state: ' + this.options.state;
            }

            return new ItemView({
                model: model,
                columns: this.options.columns,
                items: this.options.collection,
                editable: this.options.editable,
                state: 'view'
            });
        }

    });
});
