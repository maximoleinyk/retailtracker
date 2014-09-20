define(function (require) {

	var InputCell = require('./inputCell'),
		_ = require('underscore');

	require('select2');

	return InputCell.extend({

		onRender: function () {
			InputCell.prototype.onRender.apply(this, arguments);
			var select2 = this.ui.$input.select2({
				ajax: {
					url: this.options.column.get('url'),
					dataType: 'jsonp',
					quietMillis: 100,
					data: function (term) {
						return {
							q: term
						}
					},
					results: function (data) {
						return {
							results: data
						};
					}
				},
				initSelection: _.bind(this.initSelection, this),
				formatResult: _.bind(this.formatter, this),
				formatSelection: _.bind(this.formatter, this)
			});
			select2.on('select2-selecting', _.bind(this.onSelection, this));
		},

		// @Override
		getType: function () {
			return 'hidden';
		},

		getValue: function (object) {
			return object.id;
		},

		getPlaceholder: function () {
			return 'Choose something';
		},

		onSelection: function (e) {
			var self = this,
				column = this.options.column,
				selectionHandler = column.get('onSelection'),
				value = this.getValue(e.object);

			if (_.isFunction(selectionHandler)) {
				selectionHandler(e.object, this.model);
			}

			this.model.set(column.get('field'), value);

			setTimeout(function () {
				self.nextCell();
			}, 0);
		},

		initSelection: function ($el, callback) {
			var formatter = this.options.column.get('formatter'),
				value = $el.val();

			callback(formatter(value, this.model));
		},

		formatter: function (data) {
			var meta = this.options.column,
				formatter = meta.get('formatter');

			return (formatter) ? formatter(data) : data[this.model.get(meta.get('field'))];
		},

		activate: function () {
			this.ui.$input.select2('open');
		}

	});

});
