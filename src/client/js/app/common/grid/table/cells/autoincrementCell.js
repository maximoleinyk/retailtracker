define(function (require) {
    'use strict';

	var ViewCell = require('./viewCell'),
		_ = require('underscore');

	return ViewCell.extend({

		renderValue: function () {
			this.appendValue(this.options.cellManager.getRowIndex() + 1);
		}

	});

});
