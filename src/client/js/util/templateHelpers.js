define(function(require) {

    var numeral = require('numeral'),
		moment = require('moment'),
        _ = require('underscore'),
        Handlebars = require('handlebars');

    var helpers = {

        date: function(value, format) {
            var dateFormat = 'DD MMM YYYY';
            if (typeof format === 'string') {
                dateFormat = format;
            }
            return moment(value).format(dateFormat);
        },

        amount: function(value) {
            return numeral(value).format('0,0.00');
        },

        number: function(value) {
            return numeral(value).format('0,0');
        },

        abbrNumber: function(count) {
            count = +count || 0;

            if (count > 999) {
                return numeral(count).format('0.0a');
            }

            return count;
        },

        money: function(value) {
            try {
                return numeral(value).format('0.00');
            } catch (e) {
                return value;
            }
        }

    };

    _.each(helpers, function(fn, name) {
        Handlebars.registerHelper(name, fn);
    });

    return helpers;
});
