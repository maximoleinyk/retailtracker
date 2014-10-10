define(function (require) {

	var AbstractCell = require('./abstractCell');

	return AbstractCell.extend({

		template: require('hbs!./buttons/defaultButton'),

		ui: {
			$button: 'button'
		},

		templateHelpers: function () {
			return {
				label: _.bind(this.getLabel, this)
			}
		},

		getLabel: function () {
			return this.options.label;
		},

		action: function (e) {
			this.options.action(e);
		},

		activate: function () {
			var self = this;

			// setTimeout for preventing simultaneous click on button within element focusing
			setTimeout(function () {
				if (typeof self.ui.$button === 'object') {
					self.ui.$button.focus();
				}
			}, 0);
		}

	});

});
