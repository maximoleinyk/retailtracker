define(function (require) {
    'use strict';

    var http = require('./http'),
        Promise = require('rsvp').Promise,
        _ = require('underscore'),
        response = {};

    _.each(http, function (func, method) {
        response[method] = function (url, data) {
            return new Promise(function (resolve, reject) {
                func.call(window, url, data, function (err, result) {
                    return err ? reject(err) : resolve(result);
                });
            });
        };
    });

    return response;
});