define(function (require) {
	'use strict';

	var InputCell = require('./inputCell'),
		_ = require('underscore');

	require('select2');

	return InputCell.extend({

		onRender: function () {
			InputCell.prototype.onRender.apply(this, arguments);

			var dataFunc = this.options.column.get('data'),
				config = {},
				data = _.isFunction(dataFunc) ? dataFunc(this.options.model) : _.isArray(dataFunc) ? dataFunc : null;

			if (this.options.column.get('url')) {
				config = _.extend(config, {
					ajax: {
						url: this.options.column.get('url'),
						dataType: 'jsonp',
						quietMillis: 100,
						data: function (term) {
							return {
								q: term
							};
						},
						results: function (data) {
							return {
								results: data
							};
						}
					}
				});
			} else if (data) {
				config = _.extend(config, {
					data: data
				});
			} else {
				throw 'Select cell should have at least \'url\' or \'data\' attributes.';
			}

			config = _.extend(config, {
				initSelection: _.bind(this.initSelection, this),
				formatResult: _.bind(this.formatResult, this),
				formatSelection: _.bind(this.formatResult, this)
			});

			var select2 = this.ui.$input.select2(config);
			select2.on('select2-selecting', _.bind(this.onSelection, this));

			if (this.options.column.get('selectFirst')) {
				select2.val(data[0].id).trigger('change');
			}
		},

		// @Override
		getType: function () {
			return 'hidden';
		},

		getPlaceholder: function () {
			return this.options.column.get('placeholder');
		},

		updateModel: function () {
			// this.ui.$input.val() will be a formatted value
		},

		onSelection: function (e) {
			var self = this,
				column = this.options.column,
				selectionHandler = column.get('onSelection');

			if (_.isFunction(selectionHandler)) {
				selectionHandler(e.object, this.model);
			}

			_.defer(function () {
				self.nextCell();
			});
		},

		initSelection: function ($el, callback) {
			var id = this.model.get(this.options.column.get('field')),
				value = id ? {
					id: id,
					text: this.formatResult(this.model.toJSON())
				} : null;

			callback(value);
		},

		formatResult: function (object) {
			var column = this.options.column,
				formatResult = column.get('formatResult');

			return (formatResult) ? formatResult(object) : object[column.get('field')];
		},

		activate: function () {
			this.ui.$input.select2('open');
		},

		disable: function () {
			this.ui.$input.select2('enable', false);
		},

		enabled: function () {
			this.ui.$input.select2('enable', true);
		}

	});

});
