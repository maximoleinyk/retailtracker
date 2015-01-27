define(function (require) {
	'use strict';

	var _ = require('underscore');

	return {
		exists: function (key, model) {
			var value = model.get(key);

			if (value === void 0 || value === null) {
				return false;
			}

			if (typeof value === 'string') {
				return value.replace(/^\s+|\s+$/gm, '').length > 0;
			} else {
				return true;
			}
		},

		minLength: function (key, min, model) {
			var value = model.get(key);
			if (_.isNumber(value)) {
				value = '' + value;
			}
			return value && (value.length >= (min || 0));
		},

		maxLength: function (key, max, model) {
			var value = model.get(key);
			if (_.isNumber(value)) {
				value = '' + value;
			}
			return !value || (value.length <= (max || 0));
		},

		rangeLength: function (key, range, model) {
			return (this.minLength(key, range[0], model) &&
				this.maxLength(key, range[1], model));
		},

		minValue: function (key, min, model) {
			var value = model.get(key);
			return value && (value >= (min || 0));
		},

		maxValue: function (key, min, model) {
			var value = model.get(key);
			return value && (value <= (min || 0));
		},

		range: function (key, range, model) {
			return (this.minValue(key, range[0], model) &&
				this.maxValue(key, range[1], model));
		},

		oneOf: function (key, searchValues, model) {
			return _.contains(searchValues, model.get(key));
		},

		equalTo: function (key, test, model) {
			return model.get(key) == test;
		},

		contains: function (key, searchPattern, model) {
			var value = model.get(key);
			return value && (value.indexOf(searchPattern) > -1);
		},

		beginsWith: function (key, searchPattern, model) {
			var value = model.get(key);
			return value && (value.indexOf(searchPattern) === 0);
		},

		endsWith: function (key, searchPattern, model) {
			var value = model.get(key);
			return value && (value.indexOf(searchPattern, value.length - searchPattern.length) > -1);
		},

		matches: function (key, pattern, model) {
			var value = model.get(key),
				regEx = new RegExp(pattern);
			return value && regEx.test(value);
		},

		isNumeric: function (key, model) {
			var value = model.get(key);
			if (_.isString(value)) {
				value = parseFloat(value);
			}
			return !isNaN(value) && _.isNumber(value);
		},

		// Compares the value of one field with another.
		// Useful for confirm password validations.
		sameValue: function (key, key2, model) {
			// only run if both values have been provided.
			// assumes the exists validation will handle
			// the case where values are not provided.
			if (model.get(key) && model.get(key2)) {
				return model.get(key) === model.get(key2);
			}

			return true;
		},

		// Compares the value of one field with another.
		notSameValue: function (key, key2, model) {
			// only run if both values have been provided.
			// assumes the exists validation will handle
			// the case where values are not provided.
			if (model.get(key) && model.get(key2)) {
				return model.get(key) !== model.get(key2);
			}

			return true;
		}
	};
});
