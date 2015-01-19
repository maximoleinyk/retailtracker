/*global Bloodhound*/
define(function (require) {
	'use strict';

	var InputCell = require('./inputCell'),
		_ = require('underscore'),
		$ = require('jquery');

	require('typeahead');

	return InputCell.extend({

		onRender: function () {
			InputCell.prototype.onRender.apply(this, arguments);

			var column = this.options.column,
				remoteConfig = {
					url: column.get('url'),
					replace: function (url, query) {
						return url + '?' + $.param(_.extend((column.get('queryParams') || {}), {
							match: query
						}));
					}
				},
				bestPictures = new Bloodhound({
					datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
					queryTokenizer: Bloodhound.tokenizers.whitespace,
					remote: remoteConfig
				});

			bestPictures.initialize();

			this.ui.$input.typeahead({
					minLength: 2
				},
				{
					display: column.get('display'),
					source: bestPictures.ttAdapter(),
					templates: {
						empty: column.get('emptySuggestionText'),
						suggestion: column.get('suggestionTemplate')
					}
				})
		}

	});

});
