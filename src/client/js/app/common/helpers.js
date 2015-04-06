define(function (require) {
	'use strict';

	var _ = require('underscore'),
		moment = require('moment'),
		Handlebars = require('handlebars'),
		context = require('cs!app/common/context'),
		numeral = require('numeral'),
		i18n = require('cs!app/common/i18n');

	moment.locale('ru');
	numeral.language('ru', {
		delimiters: {
			thousands: ' ',
			decimal: ','
		},
		abbreviations: {
			thousand: 'тыс.',
			million: 'млн',
			billion: 'b',
			trillion: 't'
		},
		ordinal: function () {
			// not ideal, but since in Russian it can taken on
			// different forms (masculine, feminine, neuter)
			// this is all we can do
			return '.';
		},
		currency: {
			symbol: 'руб.'
		}
	});

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
		amount: function (value, currencyCode) {
			return numeral(value).format('00.00');
		},
		formatUser: function (user) {
			if (context.get('account.owner._id') === user.id) {
				return i18n.get('you');
			} else {
				return user.firstName + ' ' + user.lastName;
			}
		},
		money: function(value) {
			return numeral(value).format('$0,0.00');
		}
	};

	_.each(helpers, function (fn, name) {
		Handlebars.registerHelper(name, fn);
	});

	return helpers;
});
