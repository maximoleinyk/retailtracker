define(function (require) {
	'use strict';

	var $ = require('jquery'),
		_ = require('underscore'),
		eventBus = require('app/common/eventBus');

	var headers = {},
		statusCode = {
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
		},
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
				statusCode: statusCode
			}, options);

			if (data) {
				params.data = JSON.stringify(data);
				params.contentType = 'application/json';
			}

			eventBus.trigger('http:request:start');
			eventBus.trigger('request');

			return $.ajax(params).always(function () {
				eventBus.trigger('http:request:stop');
			});
		};

	return {
		setHeaders: function (object) {
			object = object || {};
			headers = _.extend(headers, object);
			$.ajaxSetup({
				beforeSend: function (xhr) {
					_.each(headers, function (value, key) {
						xhr.setRequestHeader(key, value);
					});
				}
			});
		},
		unsetHeader: function (name) {
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
		},
		statusCode: statusCode
	};

});
