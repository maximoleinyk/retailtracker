define(function (require) {

	var ButtonCell = require('./buttonCell'),
		_ = require('underscore'),
		Marionette = require('marionette');

	return ButtonCell.extend({

		template: require('hbs!../cells/buttons/dropdownButton'),

		ui: {
			$button: '[data-id="button"]',
            $item: '[data-id="item"]'
		},

        events: {
            'click @ui.$button': 'action',
            'click @ui.$item': 'applyItemAction'
        },

		templateHelpers: function () {
			var self = this;

			return {
				actions: self.options.actions,
				buttonClassName: self.options.buttonClassName,
				buttonIcon: self.options.buttonIcon
			}
		},

		action: function () {
			var action = this.options.onAction;

			if (action) {
				action.apply(this, arguments);
			}
		},

		applyItemAction: function (e) {
			var methodName = Marionette.$(e.currentTarget).attr('data-action-id'),
				method = this.options[methodName];

			if (method) {
				method.apply(this, arguments);
			}
		}

	});

});
