define(function (require) {

	var AbstractCell = require('./abstractCell');

	return AbstractCell.extend({

		template: require('hbs!./buttonCell'),

		ui: {
			$button: 'button'
		},

		templateHelpers: function () {
			return {
				label: _.bind(this.getLabel, this)
			}
		},

		getRootElement: function () {
			return this.ui.$button;
		},

		getLabel: function () {
			return 'Click';
		},

		action: function (e) {
			this.options.action(e);
		},

		activate: function () {
			var self = this;

			// setTimeout for preventing simultaneous click on button within element focusing
			setTimeout(function () {
				self.ui.$button.focus();
			}, 0);
		}

	});

});
