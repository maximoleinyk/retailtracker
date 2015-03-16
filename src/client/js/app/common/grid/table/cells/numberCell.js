define(function (require) {
	'use strict';

	var InputCell = require('./inputCell');

	return InputCell.extend({

		updateModel: function () {
			var property = this.options.column.get('field'),
				value = this.ui.$input.val();

			this.model.set(property, +value);
		}

	});

});
