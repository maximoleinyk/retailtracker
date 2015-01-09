define(function (require) {
    'use strict';

	var AbstractCell = require('./abstractCell'),
		_ = require('underscore'),
		textTemplate = require('hbs!./viewCell.hbs'),
		linkTemplate = require('hbs!./linkCell.hbs');

	return AbstractCell.extend({

		getTemplate: function() {
			if (this.options.column.get('url')) {
				return linkTemplate;
			} else {
				return textTemplate;
			}
		},

		addAttributes: function () {
            // do nothing
		},

		appendValue: function(value) {
			var modelUrl = this.options.column.get('url'),
				hasUrl = this.canBeFormatted && !(_.isUndefined(modelUrl) || _.isNull(modelUrl)),
				url = hasUrl && _.isFunction(modelUrl) ? modelUrl(this.model) : modelUrl;

			if (hasUrl) {
				this.$el.find('a').attr('href', url).text(value);
			} else {
				this.$el.text(value);
			}
		}

	});

});
