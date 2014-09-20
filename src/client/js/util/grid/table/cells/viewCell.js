define(function (require) {

	var AbstractCell = require('./abstractCell'),
		_ = require('underscore');

	return AbstractCell.extend({

		template: require('hbs!./viewCell'),

		addAttributes: function () {
		},

		appendValue: function (value) {
			this.$el.text(value);
		}

	});

});
