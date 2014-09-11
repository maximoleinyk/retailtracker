define(function (require) {

    var Marionette = require('marionette'),
        FooterCell = require('./footerCell');

    return Marionette.CollectionView.extend({
        template: require('hbs!./footer'),
        itemView: true,

        initialize: function () {
            this.collection = new Backbone.Collection(_.map(this.options.columns, function (value, key) {
                return _.extend(value, {
                    field: key
                });
            }));
            this.model = new this.options.items.model({});
        },

        buildItemView: function (model) {
            var type = model.get('type') || 'view',
                options = {
                    model: this.model,
                    meta: model
                };

            switch (type) {
                case 'view':
                    return new ViewCell(options);
                case 'string':
                    return new TextCell(options);
                case 'date':
                    return new DatepickerCell(options);
                case 'boolean':
                    return new BooleanCell(options);
            }
        }
    });

});
