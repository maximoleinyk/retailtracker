define(function (require) {
    'use strict';

    var Backbone = require('backbone'),
        eventBus = require('cs!app/common/eventBus'),
        _ = require('underscore');

    var headers = {},
        request = function (method, url, data, callback, options) {

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
                        response = xhr.responseText;
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
                        eventBus.trigger('http:401', text);
                    },
                    403: function (xhr) {
                        eventBus.trigger('http:403', { error: xhr.responseText });
                    }
                }
            }, options);

            if (data) {
                params.data = JSON.stringify(data);
                params.contentType = 'application/json';
            }

            eventBus.trigger('http:request:start');

            return Backbone.$.ajax(params).always(function () {
                eventBus.trigger('http:request:stop');
            });
        };

    return {
        setHeaders: function (object) {
            object = object || {};
            headers = _.extend(headers, object);
            Backbone.$.ajaxSetup({
                beforeSend: function (xhr) {
                    _.each(headers, function (value, key) {
                        xhr.setRequestHeader(key, value);
                    });
                }
            });
        },
		unsetHeader: function(name) {
			delete headers[name];
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
