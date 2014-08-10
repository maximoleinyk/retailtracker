define(function(require) {
	'use strict';

	var Backbone = require('backbone'),
		Model = Backbone.Model.extend({
			idAttribute: '_id'
		});

	return new Model();
});
