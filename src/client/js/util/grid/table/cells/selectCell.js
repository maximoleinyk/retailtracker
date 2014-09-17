define(function (require) {

	var Marionette = require('marionette');

	require('select2');

	return Marionette.ItemView.extend({

		template: require('hbs!./selectCell'),
		tagName: 'td',

		ui: {
			$input: 'input[type="hidden"]'
		},

		onRender: function() {
			this.ui.$input.select2({
				url: this.options.collection.url,
				dataType: 'jsonp',
				quietMillis: 100,
				data: function(term, page) {
					return {
						q: term,
						page_limit: 7,
						page: page
					}
				},
				formatResult: this.formatResult,
				formatSelection: this.formatSelection
			});
		},

		formatResult: function(data) {
			return data;
		},

		formatSelection: function(data) {
			return data;
		}

	});

});
