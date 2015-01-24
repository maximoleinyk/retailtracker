define(function (require) {
	'use strict';

	require('select2');
	require('select2locale');

	return function ($el, opts) {
		opts = opts || {};

		var label = $el.closest('.form-group').find('label').first(),
			handler = function () {
				$el.select2('open');
			},
			result = $el.select2(opts);

		label.off('click', handler).on('click', handler);

		return result;
	};
});
