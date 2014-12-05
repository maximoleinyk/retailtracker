define(function (require) {
    'use strict';

	var AbstractCell = require('./abstractCell'),
		_ = require('underscore');

	return AbstractCell.extend({

		template: require('hbs!./viewCell.hbs'),

		addAttributes: function () {
            // do nothing
		},

		appendValue: function (value) {
			this.$el.text(value);
		}

	});

});
