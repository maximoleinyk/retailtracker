define(function (require) {

    var Backbone = require('backbone'),
        Marionette = require('marionette');

    return Marionette.CollectionView.extend({

        template: require('hbs!./abstractRow'),
        itemView: true,
        tagName: 'tr',

        initialize: function (options) {
            this.state = options.state || false;
            this.collection = new Backbone.Collection(this.options.columns);
        },

		changeState: function(state) {
			this.state = state;
			this.trigger('change:state', state, this, this.model);
		},

        render: function(index) {
            this.rowIndex = index;
            return Marionette.CollectionView.prototype.render.apply(this, arguments);
        },

        getIndex: function() {
            return this.rowIndex;
        },

		getCellIndex: function(column) {
			var index = -1;

			this.collection.each(function (model, i) {
				if (model.get('field') === column.get('field')) {
					index = i;
					return false;
				}
			});

			return index;
		},

		first: function() {
			return this.children.findByIndex(this.options.numerable ? 1 : 0);
		},

		next: function (column) {
			var index = this.getCellIndex(column);

			return this.children.findByIndex((this.collection.length - 1 === index) ? index : index + 1);
		},

		prev: function (column) {
			var index = this.getCellIndex(column),
				allowedIndex = this.options.numerable ? 1 : 0;

			return this.children.findByIndex((index === allowedIndex) ? allowedIndex : --index);
		},

        buildItemView: function (column, itemView, itemViewOptions) {
            itemViewOptions = itemViewOptions || {};

            var type = column.get('type') || 'view',
                options = _.extend(itemViewOptions, {
                    model: this.model,
                    collection: this.options.items,
                    column: column,
                    cellManager: this
                });

            return this.buildCellView(type, column, options)
        },

        buildCellView: function (type, column, options) {
            throw 'Method not implemented';
        },

        removeItem: function(model) {
        }

    });

});
