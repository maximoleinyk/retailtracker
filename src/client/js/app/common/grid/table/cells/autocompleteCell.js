/*global Bloodhound*/
define(function (require) {
	'use strict';

	var InputCell = require('./inputCell'),
		_ = require('underscore'),
		Handlebars = require('handlebars'),
		$ = require('jquery');

	require('typeahead');

	return InputCell.extend({

		onRender: function () {
			InputCell.prototype.onRender.apply(this, arguments);

			var remoteConfig = {
				url: '/employees/fetch',
				replace: function (url, query) {
					return url + '?match=' + query;
				}
			};

			var bestPictures = new Bloodhound({
				datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
				queryTokenizer: Bloodhound.tokenizers.whitespace,
				remote: remoteConfig
			});

			bestPictures.initialize();

			this.ui.$input.typeahead({
					minLength: 2
				},
				{
					display: function (employee) {
						return employee.email;
					},
					source: bestPictures.ttAdapter(),
					templates: {
						suggestion: Handlebars.compile('<p>{{firstName}} {{lastName}} &lt;{{email}}&gt;</p>')
					}
				})
		}

	});

});
