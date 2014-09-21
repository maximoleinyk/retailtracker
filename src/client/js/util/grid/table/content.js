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

        buildItemView: function(model, View, options) {
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
                state: state
            });

			row.on('change:state', _.bind(this.handleStateChange, this));

			return row;
        },

		itemViewOptions: function() {
			return {
				state: this.getState()
			}
		},

		getState: function(options) {
			options = options || {};

			return options.state ? options.state : this.options.state;
		},

		handleStateChange: function(state, view, model) {
			var index = -1,
				originItemViewOptions = this.itemViewOptions;

			this.children.find(function(v, i) {
				if (v.cid === view.cid) {
					index = i;
					return v;
				}
			});

			this.itemViewOptions = function() {
				return {
					state: state
				}
			};
			this.removeItemView(model);
			this.addItemView(model, true, index);
			this.itemViewOptions = originItemViewOptions;
		}

    });
});
