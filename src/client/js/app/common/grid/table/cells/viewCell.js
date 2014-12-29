define(function (require) {
    'use strict';

	var AbstractCell = require('./abstractCell'),
		_ = require('underscore');

	return AbstractCell.extend({

		template: require('hbs!./viewCell.hbs'),

		addAttributes: function () {
            // do nothing
		},

        templateHelpers: function() {
			var modelUrl = this.options.column.get('url'),
				hasUrl = this.canBeFormatted && !(_.isUndefined(modelUrl) || _.isNull(modelUrl)),
				url = hasUrl && _.isFunction(modelUrl) ? modelUrl(this.model) : modelUrl;
            return {
                text: this.model.get(this.options.column.get('field')),
				hasUrl: hasUrl,
				url: url
            };
        }

	});

});
