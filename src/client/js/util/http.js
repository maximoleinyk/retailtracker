define(function (require) {
    'use strict';

    var Backbone = require('backbone'),
        eventBus = require('util/eventBus'),
        _ = require('underscore');

    var request = function (method, url, data, callback, options) {

        if (_.isFunction(data)) {
            options = callback;
            callback = data;
            data = null;
        }

        options || (options = {});

        var params = _.extend({
            type: method,
            url: url,
            success: function (response) {
                callback(null, response);
            },
            error: function (xhr) {
                var response;
                try {
                    response = JSON.parse(xhr.responseText);
                } catch (e) {
                    response = xhr.responseText
                }
                callback(response);
            },
            statusCode: {
                400: function (result) {
                    var response;
                    try {
                        response = JSON.parse(result.responseText);
                    } catch (e) {
                        response = result.responseText;
                    }
                    eventBus.trigger('http:400', response);
                },
                401: function (xhr, status, text) {
                    eventBus.trigger('http:401', {
                        fragment: Backbone.history.fragment,
                        errorMessage: text
                    });
                },
                404: function () {
                    eventBus.trigger('http:404');
                },
                500: function () {
                    eventBus.trigger('http:500');
                },
                504: function () {
                    eventBus.trigger('http:504');
                }
            }
        }, options);

        if (data) {
            params.data = JSON.stringify(data);
            params.contentType = 'application/json';
        }

        return Backbone.$.ajax(params);
    };

    return {
        setHeaders: function (object) {
            object = object || {};
            Backbone.$.ajaxSetup({
                beforeSend: function (xhr) {
                    _.each(object, function (value, key) {
                        xhr.setRequestHeader(key, value);
                    });
                }
            });
        },
        get: function (url, callback, options) {
            return request('GET', url, callback, options);
        },
        put: function (url, data, callback, options) {
            return request('PUT', url, data, callback, options);
        },
        post: function (url, data, callback, options) {
            return request('POST', url, data, callback, options);
        },
        del: function (url, data, callback, options) {
            return request('DELETE', url, data, callback, options);
        }
    };

});
