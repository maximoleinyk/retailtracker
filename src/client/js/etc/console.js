/*global console*/
define(function() {
	'use strict';

	return {
		log: function() {
			console.log.apply(this, arguments);
		}
	};
});
