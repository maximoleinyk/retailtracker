define(function (require) {

    var Marionette = require('marionette'),
        ViewCell = require('./cells/viewCell'),
        TextCell = require('./cells/textCell'),
        DateCell = require('./cells/dateCell'),
        BoolCell = require('./cells/boolCell'),
        NumberCell = require('./cells/numberCell'),
		SelectCell = require('./cells/selectCell');

    return Marionette.CollectionView.extend({

        template: require('hbs!./row'),
        itemView: true,
        tagName: 'tr',

        initialize: function (options) {
            this.editable = options.editable || false;
            this.collection = new Backbone.Collection(this.options.columns);
        },

        buildItemView: function (column, itemView, itemViewOptions) {
            itemViewOptions = itemViewOptions || {};

            var type = column.get('type') || 'view',
                options = _.extend(itemViewOptions, {
                    model: this.model,
					collection: this.options.items,
                    meta: column
                });

            if (this.editable) {
                switch (type) {
                    case 'string':
                        return new TextCell(options);
                    case 'date':
                        return new DateCell(options);
                    case 'number':
                        return new NumberCell(options);
                    case 'boolean':
                        return new BoolCell(options);
					case 'action':
						return new column.get('instance')(options);
					case 'select':
						return new SelectCell(options);
                    default:
                        return new ViewCell(options);
                }
            } else {
                switch (type) {
                    case 'action':
                        return new column.get('instance')(options);
                    default:
                        return new ViewCell(options);
                }
            }
        }

    });

});
