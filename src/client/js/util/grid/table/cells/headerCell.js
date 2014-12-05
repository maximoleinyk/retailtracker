define(function (require) {
    'use strict';

	var ViewCell = require('./viewCell'),
		_ = require('underscore');

	return ViewCell.extend({

		tagName: 'th',

		initialize: function() {
			ViewCell.prototype.initialize.apply(this, arguments);
			this.canBeFormatted = false;
		}

	});

});
