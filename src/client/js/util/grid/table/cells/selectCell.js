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
				formatResult: _.bind(this.formatResult, this),
				formatSelection: _.bind(this.formatResult, this)
			});
			select2.on('select2-selecting', _.bind(this.onSelection, this));
		},

		// @Override
		getType: function () {
			return 'hidden';
		},

		getPlaceholder: function () {
			return this.options.column.get('placeholder');
		},

        updateModel: function() {
            // this.ui.$input.val() will be a formatted value
        },

        appendValue: function(value) {
            InputCell.prototype.appendValue.apply(this, arguments);
            if (!value) {
                this.ui.$input.select2('val', '');
            }
        },

		onSelection: function (e) {
			var self = this,
				column = this.options.column,
				selectionHandler = column.get('onSelection');

			if (_.isFunction(selectionHandler)) {
				selectionHandler(e.object, this.model);
			}

			setTimeout(function () {
				self.nextCell();
			}, 0);
		},

		initSelection: function ($el, callback) {
			callback(this.model.toJSON());
		},

		formatResult: function (object) {
			var column = this.options.column,
				formatResult = column.get('formatResult');

			return (formatResult) ? formatResult(object) : object[column.get('field')];
		},

		formatter: function (data) {
			var column = this.options.column,
				formatter = column.get('formatter');

			return (formatter) ? formatter(data) : data[column.get('field')];
		},

		activate: function () {
			this.ui.$input.select2('open');
		}

	});

});
