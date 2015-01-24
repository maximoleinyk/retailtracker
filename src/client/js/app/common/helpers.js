define(function (require) {
	'use strict';

	var _ = require('underscore'),
		moment = require('moment'),
		momentLocale = require('momentRussianLocale'),
		Handlebars = require('handlebars'),
		context = require('cs!app/common/context'),
		numeral = require('numeral'),
		i18n = require('cs!app/common/i18n');

	moment.locale('ru', momentLocale);

	var helpers = {
		date: function (value, long) {
			var date = moment(value);

			if (date.year() === moment().year() && !long) {
				return date.format('D MMMM');
			} else {
				return date.format(momentLocale.longDateFormat('LL'));
			}
		},
		time: function (value) {
			return moment(value).format(momentLocale.longDateFormat('LT'));
		},
		dateTime: function (value) {
			return helpers.date(value) + ' ' + helpers.time(value);
		},
		amount: function (value) {
			return numeral(value).format('0,0.00');
		},
		formatUser: function (user) {
			if (context.get('account.owner._id') === user.id) {
				return i18n.get('you');
			} else {
				return user.firstName + ' ' + user.lastName;
			}
		}
	};

	_.each(helpers, function (fn, name) {
		Handlebars.registerHelper(name, fn);
	});

	return helpers;
});
