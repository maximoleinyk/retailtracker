define(function (require) {
    'use strict';

    var http = require('./http'),
        Promise = require('rsvp').Promise;

    var response = {};

    _.each(http, function (func, method) {
        response[method] = function (url, data) {
            return new Promise(function (resolve, reject) {
                return func.call(window, url, data, function (err, result) {
                    err ? reject(err) : resolve(result);
                });
            });
        }
    });

    return response;
});