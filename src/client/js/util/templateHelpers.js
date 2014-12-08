define(function (require) {
    'use strict';

    var _ = require('underscore'),
        moment = require('moment'),
        momentLocale = require('momentRussianLocale'),
        Handlebars = require('handlebars'),
        context = require('cs!app/common/context'),
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
        formatUser: function (user) {
            if (context.get('owner').id === user.id) {
                return i18n.get('you');
            } else {
                return user.firstName + ' ' + user.lastName;
            }
        }
    };

    _.each(helpers, function (fn, name) {
        Handlebars.registerHelper(name, fn);
    });

    Handlebars.registerHelper('isPrimary', function (context, options) {
        if (context.primary) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });

    return helpers;
});
