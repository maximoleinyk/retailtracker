define(function (require) {
	'use strict';

	var $ = require('jquery'),
		AbstractCell = require('./abstractCell'),
		_ = require('underscore');

	return AbstractCell.extend({

		template: require('hbs!./inputCell.hbs'),

		ui: {
			$input: 'input'
		},

		events: {
			'change @ui.$input': 'updateModel'
		},

		initialize: function () {
			this.setDefaultValues();
			AbstractCell.prototype.initialize.apply(this, arguments);
		},

		registerExternalEvents: function () {
			var self = this,
				events = this.options.column.get('events');

			if (!_.isObject(events)) {
				return;
			}

			_.each(events, function (callback, eventName) {
				switch (eventName) {
					case 'blur':
						self.ui.$input.on(eventName, function (e) {
							var value = $(e.currentTarget).val(),
								next = function () {
									self.options.cellManager.enableInputs();
								};
							self.options.cellManager.disableInputs();
							callback(value, self.model, next);
						});
						break;
				}
			});
		},

		setDefaultValues: function () {
			var defaultValue = this.options.column.get('default');

			if (!_.isNull(defaultValue) && !_.isUndefined(defaultValue) && this.options.cellManager.isFooter) {
				this.model.set(this.options.column.get('field'), defaultValue);
			}
		},

		onRender: function () {
			AbstractCell.prototype.onRender.apply(this, arguments);
			this.bindInputEvents();
			this.registerExternalEvents();
		},

		bindInputEvents: function () {
			this.ui.$input.on('change', _.bind(function () {
				var field = this.options.column.get('field'),
					value = this.ui.$input.val();

				this.model.set(field, value);
			}, this));
		},

		templateHelpers: function () {
			return {
				type: _.bind(this.getType, this),
				name: _.bind(this.getName, this),
				placeholder: _.bind(this.getPlaceholder, this)
			};
		},

		updateModel: function () {
			var property = this.options.column.get('field'),
				value = this.ui.$input.val();

			this.model.set(property, value);
		},

		appendValue: function (value) {
			this.ui.$input.val(value);
		},

		getPlaceholder: function () {
			return this.options.column.get('placeholder');
		},

		getName: function () {
			return this.options.column.get('field');
		},

		getType: function () {
			return 'text';
		},

		activate: function () {
			this.ui.$input.focus().select();
		},

		disable: function () {
			this.ui.$input.attr('disabled', true);
		},

		enable: function () {
			this.ui.$input.removeAttr('disabled');
		}

	});

});
