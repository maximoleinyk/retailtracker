define(function (require) {
	'use strict';

	require('select2');
	require('select2locale');

	return function ($el, opts) {
		$el.select2(opts);
	};
});
