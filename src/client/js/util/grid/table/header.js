define(function (require) {
    'use strict';

	var Backbone = require('backbone'),
		ViewRow = require('./rows/viewRow'),
		HeaderCell = require('./cells/headerCell'),
		_ = require('underscore');

	return ViewRow.extend({

		template: require('hbs!./header.hbs'),

		initialize: function (options) {
			var attributes = {};
			_.each(options.columns, function (column) {
				attributes[column.field] = column.title;
			});
			this.model = new Backbone.Model(attributes);
			ViewRow.prototype.initialize.apply(this, arguments);
		},

		buildCellView: function (type, column, options) {
			return new HeaderCell(options);
		}

	});

});
