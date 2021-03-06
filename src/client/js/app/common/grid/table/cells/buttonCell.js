define(function (require) {
	'use strict';

	var AbstractCell = require('./abstractCell'),
		_ = require('underscore');

	return AbstractCell.extend({

		template: require('hbs!./buttons/defaultButton.hbs'),

		ui: {
			$button: '[data-id="button"]'
		},

		events: {
			'click @ui.$button': 'action'
		},

		templateHelpers: function () {
			return {
				label: _.bind(this.getLabel, this),
				buttonIcon: this.options.column.get('buttonIcon'),
				buttonTypeClass: this.options.column.get('buttonTypeClass') || 'btn-default'
			};
		},

		getLabel: function () {
			return this.options.label || this.options.column.get('label') || '';
		},

		action: function (e) {
			var action = this.options.action || this.options.column.get('action');
			action(e, this.options.model);
		},

		activate: function () {
			var self = this;
			_.defer(function () {
				if (typeof self.ui.$button === 'object') {
					self.ui.$button.focus();
				}
			});
		}

	});

});
