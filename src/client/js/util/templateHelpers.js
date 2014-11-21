define(function(require) {
	'use strict';

    var _ = require('underscore'),
        moment = require('moment'),
        momentLocale = require('momentLocales/ru'),
        Handlebars = require('handlebars'),
        context = require('cs!app/common/context');

    moment.locale('ru', momentLocale);

    var helpers = {
        date: function(value) {
            var date = moment(value);

            if (date.year() === moment().year()) {
                return date.format('D MMMM');
            } else {
                return date.format(momentLocale.longDateFormat('LL'));
            }
        },
        time: function(value) {
            return moment(value).format(momentLocale.longDateFormat('LT'));
        },

        formatUser: function(user) {
            if (context.get('owner').id === user.id) {
                return window.RetailTracker.i18n.you;
            } else {
                return user.firstName + ' ' + user.lastName;
            }
        }
    };

    _.each(helpers, function(fn, name) {
        Handlebars.registerHelper(name, fn);
    });

    return helpers;
});
