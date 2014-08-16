define(function (require) {
	'use strict';

	var rivets = require('rivets'),
		Marionette = require('marionette'),
		Backbone = require('backbone'),
		_ = require('underscore');


	if (typeof String.prototype.trim !== 'function') {
		String.prototype.trim = function () {
			return this.replace(/^\s+|\s+$/g, '');
		};
	}

	rivets.configure({
		prefix: 'data',
		templateDelimiters: [ '[', ']' ]
	});

	rivets.adapters['.'] = {
		subscribe: function (obj, keypath, callback) {
			if (!obj || !keypath || !obj.on) {
				return;
			}
			obj.on('change:' + keypath, callback);
		},
		unsubscribe: function (obj, keypath, callback) {
			if (!obj || !keypath || !obj.off) {
				return;
			}
			obj.off('change:' + keypath, callback);
		},
		read: function (obj, keypath) {
			if (!obj || !keypath) {
				return;
			}
			return obj.get ? obj.get(keypath) : obj[keypath];
		},
		publish: function (obj, keypath, value) {
			if (!obj || !keypath) {
				return;
			}

			// when we set the numeric value from the input it has a string type
			// i.e. "32", "2.3" etc. Hence why we need to parse number from string
			// into its original type to avoid further inconsistencies with raw JSON
			if (value && typeof value === 'string') {
				// heading plus sign is needed for parsing numeric values (including
				// those with floating point) and string concatenation is needed
				// because: NaN === NaN -> false. But we also should skip values
				// which was written with explicit specifying of leading zeros e.g. "000001"
				// we have about 16 digits of precision so we also need to validate this
				value = (+value + '' === 'NaN') ? value : (/^0+\d+/.test(value)) ? value : (value.length > 16) ? value : +value;
			}

			return obj.set ? obj.set(keypath, value) : obj[keypath] = value;
		}
	};

	function bind(view, bindings) {
		bindings = bindings || {
			model: view.model
		};
		view.rv = rivets.bind(view.$el, bindings);
	}

	function unbind(view) {
		if (view.rv) {
			view.rv.unbind();
		}
	}

	var listeners = {
		autofocus: function (el) {
			el.focus();
		}
	};

	var constructor = Marionette.View.prototype.constructor;
	Marionette.View.prototype.constructor = function () {
		var self = this;

		this.validation = {
			reset: function () {
				var $wrapper = self.$el.find('[data-validation]')
					.text('')
					.closest('.form-group, .validation-group')
					.removeClass('has-error');

				$wrapper.each(function () {
					var $el = Backbone.$(this);
					if ($el.data('hidden')) {
						$el.addClass('hidden');
						$el.removeData('hidden');
					}
				});
			},
			show: function (messages) {
				if (!_.isObject(messages)) {
					return;
				}

				_.each(messages, function (value, key) {
					var $el = self.$el.find('[data-validation="' + key + '"]').text(value),
						$wrapper = $el.closest('.form-group, .validation-group').addClass('has-error');

					if ($wrapper.hasClass('hidden')) {
						$wrapper.data('hidden', 'true').removeClass('hidden');
					}
				});

				var firstErrorGroup = self.$el.find('.has-error').first();
				if (!firstErrorGroup.length) {
					firstErrorGroup = self.$el.find('[autofocus]').closest('.form-group, .validation-group');
				}
				firstErrorGroup.find('input, select, textarea').focus();
			}
		};

		this.listenTo(this, 'render', function () {
			if (this.binding) {
				switch (typeof this.binding) {
					case 'object':
						return bind(this, this.binding);
					case 'function':
						return bind(this, this.binding.call(this));
					default:
						return bind(this);
				}
			}
		}, this);

		this.listenTo(this, 'show', function () {
			_.each(listeners, function (callback, attribute) {
				callback(this.$el.find('[' + attribute + ']'));
			}, this);
		}, this);

		this.listenTo(this, 'close', function () {
			if (this.binding) {
				return unbind(this);
			}
		}, this);

		constructor.apply(this, arguments);
	};

});
