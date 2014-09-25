define(function (require) {

	var Marionette = require('marionette');

	return Marionette.ItemView.extend({

		tagName: 'td',

		initialize: function () {
			this.canBeFormatted = true;
			this.bindEvents();
			this.listenEvents();
		},

        invalid: function() {
            this.$el.addClass('has-error');
        },

        valid: function() {
            this.$el.removeClass('has-error');
        },

		bindEvents: function () {
			var field = this.options.column.get('field');

			switch (field) {
				case 'numerable':
				case 'editable':
					break;
				default:
					this.listenTo(this.model, 'change:' + field, this.renderValue, this);
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
            this.bindInputEvents();
		},

        bindInputEvents: function() {
            var rootElement = this.getRootElement();

            rootElement.on('change', _.bind(function() {
                var field = this.options.column.get('field'),
                    value = rootElement.val();

                this.model.set(field, value);
            }, this));
        },

		setTextAlign: function () {
			var map = {
					autoincrement: 'increment',
					number: 'numeric',
					edit: 'action'
				},
				type = this.options.column.get('type'),
				className = map[type];

			if (className) {
				this.$el.addClass(className);
			}
		},

		applyColumnWidth: function () {
			var width = this.options.column.get('width');

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
