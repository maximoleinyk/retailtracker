define(function () {
	'use strict';

	return {
		add: function (key, value) {
			return sessionStorage.setItem(key, value);
		},
		remove: function (key) {
			return sessionStorage.removeItem(key);
		},
		get: function (key) {
			return sessionStorage.getItem(key);
		}
	};
});
