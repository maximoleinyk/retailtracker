define(function (require) {
	'use strict';

	var InputCell = require('./inputCell'),
		_ = require('underscore');

	return InputCell.extend({

		updateModel: function () {
			var field = this.options.column.get('field'),
				value = this.ui.$input.val(),
				obtainFunction = this.options.column.get('value');

			if (_.isFunction(obtainFunction)) {
				value = obtainFunction(value, this.model);
			}

			// prevent invocation of renderValue function
			this.model.set(field, value, {silent: true});
		}

	});

});
