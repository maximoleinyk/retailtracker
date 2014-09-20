define(function (require) {

	var Marionette = require('marionette');

	return Marionette.ItemView.extend({

		tagName: 'td',

		initialize: function () {
			this.canBeFormatted = true;
			this.bindEvents();
			this.listenEvents();
		},

		bindEvents: function() {
			var field = this.options.column.get('field');

			switch (field) {
				case 'numerable':
				case 'editable':
					break;
				default:
					this.model.on('change:' + field, _.bind(this.renderValue, this));
					break;
			}
		},

		listenEvents: function () {
			var self = this;

			this.$el.on('keydown', function (e) {
				if (e.keyCode !== 13) {
					return;
				}
				self[e.shiftKey ? 'prevCell' : 'nextCell']();
			});
		},

		onRender: function () {
			this.renderValue();
			this.addAttributes();
			this.setTextAlign();
			this.applyColumnWidth();
		},

		setTextAlign: function() {
			var type = this.options.column.get('type');

			if (type !== 'number') {
				return;
			}

			this.$el.addClass('numeric');
		},

		applyColumnWidth: function () {
			var type = this.options.column.get('type'),
				width = this.options.column.get('width');

			if (type === 'autoincrement' || type === 'edit') {
				return this.$el.css({width: '1px'});
			}

			if (width) {
				this.$el.css({width: width});
			}
		},

		addAttributes: function () {
			var attributes = this.options.column.get('attributes') || {};

			_.each(attributes, function (value, key) {
				this.getRootElement().attr(key, value);
			}, this);
		},

		getRootElement: function () {
			return this.$el;
		},

		renderValue: function () {
			var value = this.model.get(this.options.column.get('field')),
				formatter = this.options.column.get('formatter');

			if (this.canBeFormatted && _.isFunction(formatter)) {
				value = formatter(value, this.model);
			}

			this.appendValue(value);
		},

		appendValue: function (value) {
			// abstract method
		},

		nextCell: function () {
			var nextCell = this.options.cellManager.next(this.options.column);

			if (nextCell) {
				nextCell.activate();
			}
		},

		prevCell: function () {
			var nextCell = this.options.cellManager.prev(this.options.column);

			if (nextCell) {
				nextCell.activate();
			}
		},

		activate: function () {
			// abstract method
		}

	});

});
