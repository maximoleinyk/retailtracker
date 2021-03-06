define(function (require) {
	'use strict';

	var _ = require('underscore'),
		moment = require('moment'),
		Handlebars = require('handlebars'),
		context = require('cs!app/common/context'),
		numeral = require('numeral'),
		i18n = require('cs!app/common/i18n');

	moment.locale('ru');
	numeral.language('uk-UA', {
		delimiters: {
			thousands: ' ',
			decimal: ','
		},
		abbreviations: {
			thousand: 'тис.',
			million: 'млн',
			billion: 'млрд',
			trillion: 'блн'
		},
		ordinal: function () {
			// not ideal, but since in Ukrainian it can taken on
			// different forms (masculine, feminine, neuter)
			// this is all we can do
			return '';
		},
		currency: {
			symbol: '\u20B4'
		}
	});
	numeral.language('uk-UA');

	var helpers = {
		date: function (value, long) {
			var date = moment(value);

			if (date.year() === moment().year() && !long) {
				return date.format('D MMMM');
			} else {
				return date.format('D MMMM YYYY г.');
			}
		},
		time: function (value) {
			return moment(value).format('HH:mm');
		},
		dateTime: function (value) {
			return helpers.date(value) + ' ' + helpers.time(value);
		},
		amount: function (value) {
			return numeral(value).format('0,0.00');
		},
		amountUnformat: function(value) {
			return numeral().unformat(value);
		},
		formatUser: function (user) {
			if (context.get('account.owner._id') === user.id) {
				return i18n.get('you');
			} else {
				return user.firstName + ' ' + user.lastName;
			}
		},
		money: function (value) {
			return numeral(value).format('$ 0,0.00');
		},
		currencyRate: function (value) {
			return numeral(value).format('0.0000');
		}
	};

	_.each(helpers, function (fn, name) {
		Handlebars.registerHelper(name, fn);
	});

	return helpers;
});
