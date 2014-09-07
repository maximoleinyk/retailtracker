(function (callback) {

	if (typeof module === 'object') {
		var _ = require('underscore'),
			Backbone = require('backbone'),
			Marionette = require('marionette');
		module.exports = callback(_, Backbone, Marionette);
	} else if (typeof define === 'function' && define.amd) {
		define(['underscore', 'backbone', 'marionette'], callback);
	}

}(function (_, Backbone, Marionette) {

	var $ = Marionette.$;

	return function(config) {
		config = config || {
			collection: new Backbone.Collection(),
			columns: {}
		};

		return Marionette.Layout.extend({

			$el: config.$el,

			initialize: function() {
				this.registerEventHandlers();
			},

			registerEventHandlers: function() {
				this.listenTo(this.collection, "reset", this.render);
			},

			render: function() {
				this.fragment = document.createDocumentFragment();

				var table = $('<table/>');

				table.append(this.buildHeader());
				table.append(this.buildContent());

				this.fragment.appendChild(table);
				this.$el.append(this.fragment);
			},

			buildContent: function() {
				var tbody = $('<tbody/>');

				config.collection.each(function(model) {
					var tr = $('<tr/>');

					_.each(config.columns, function(value, property) {
						var td = $('<td/>'),
							text = model.get(property);

						if (typeof value.format === 'function') {
							text = value.format(text);
						}

						td.text(text);
						tr.append(td);
					});

					tbody.append(tr);
				});

				return tbody;
			},

			buildHeader: function() {
				var thead = $('<thead/>'),
					tr = $('<tr/>');

				_.each(config.columns, function(value) {
					var th = $('<th/>'),
						text = typeof value.title === 'function' ? value.title() : value.title;
					th.text(text);
					tr.append(th);
				});

				thead.append(tr);

				return thead;
			}
		});
	}

}));
