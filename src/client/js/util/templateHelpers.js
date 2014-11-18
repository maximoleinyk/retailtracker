define(function(require) {
	'use strict';

    var _ = require('underscore'),
        Handlebars = require('handlebars');

    var helpers = {
    };

    _.each(helpers, function(fn, name) {
        Handlebars.registerHelper(name, fn);
    });

    return helpers;
});
