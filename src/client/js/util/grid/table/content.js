define(function (require) {

	var Marionette = require('marionette'),
		EditRow = require('./rows/editRow'),
		ViewRow = require('./rows/viewRow');

	return Marionette.CollectionView.extend({

		template: require('hbs!./content'),
		itemView: true,

		initialize: function() {
			this.order = {};
		},

		// @Override
		renderItemView: function (view, index) {
			view.render(index);
			this.appendHtml(this, view, index);
		},

		// @Override
		appendHtml: function (collectionView, itemView, index) {
			var children = collectionView.$el.children();

			if (collectionView.isBuffering) {
				collectionView.elBuffer.appendChild(itemView.el);
				collectionView._bufferedChildren.push(itemView);
			} else {
				if (index > 0) {
					children.eq(index - 1).after(itemView.el);
				} else {
					if (children.length) {
						children.eq(index).before(itemView.el);
					} else {
						collectionView.$el.append(itemView.el);
					}
				}

			}
		},

		buildItemView: function (model, View, options) {
			var ItemView,
				state = this.getState(options);

			if (state === 'view') {
				ItemView = ViewRow;
			} else if (state === 'edit') {
				ItemView = EditRow;
			} else {
				throw 'Unknown state: ' + this.options.state;
			}

			var row = new ItemView({
				model: model,
				columns: this.options.columns,
				items: this.options.collection,
				editable: this.options.editable,
				onSave: this.options.onSave,
				onDelete: this.options.onDelete,
				state: state
			});

			this.order[model.cid] = options.index;
			row.on('change:state', _.bind(this.handleStateChange, this));

			return row;
		},

		itemViewOptions: function (model, index) {
			return {
				state: this.getState(),
				index: index
			}
		},

		getState: function (options) {
			options = options || {};

			return options.state ? options.state : this.options.state;
		},

		handleStateChange: function (state, view, model) {
			var index = this.order[model.cid],
				originItemViewOptions = this.itemViewOptions;

			this.itemViewOptions = function () {
				return {
					state: state,
					index: index
				}
			};
			this.removeItemView(model);
			this.addItemView(model, true, index);
			this.itemViewOptions = originItemViewOptions;
		}

	});
});
