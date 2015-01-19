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

			var self = this,
				options = _.defaults(this.options.column.get('options') || {}, {
					emptySuggestionText: 'Empty'
				}),
				remoteConfig = {
					url: options.url,
					replace: function (url, query) {
						return url + '?' + $.param(_.extend((options.queryParams || {}), {
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
					hint: true,
					highlight: true,
					minLength: 1
				},
				{
					display: options.display,
					source: bestPictures.ttAdapter(),
					templates: {
						empty: options.emptySuggestionText,
						suggestion: options.suggestionTemplate
					}
				}).on('typeahead:selected', function (obj, datum) {
					self.model.set(self.options.column.get('field'), options.display(datum));
				});
		}

	});

});
