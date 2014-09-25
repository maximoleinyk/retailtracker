define(function (require) {

	var ButtonCell = require('./buttonCell'),
		_ = require('underscore');

	return ButtonCell.extend({

		template: require('hbs!./buttons/dropdownButton'),

		ui: {
			$button: '[data-id="button"]'
		},

		templateHelpers: function () {
			return {
				actions: function() {
					return [{
						action: 'onDelete',
						label: 'Delete'
					}]
				}
			}
		},

		action: function (e) {
			this.options.action(e);
		},

		onDelete: function() {
			this.options.onDelete();
		}

	});

});
