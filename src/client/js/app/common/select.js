define(function (require) {
	'use strict';

	var $ = require('jquery'),
		_ = require('underscore'),
		eventBus = require('app/common/eventBus'),
		i18n = require('cs!app/common/i18n');

	require('select2');

	return function ($el, options) {
		options = options || {};

		if (!_.isUndefined(options.format)) {
			switch (options.format) {
				case 'warehouse':
				case 'priceList':
				case 'currency':
					options.formatSelection = options.formatResult = function (object) {
						return object.text ? object.text : object.name;
					};
					break;
				case 'employee':
					options.formatSelection = options.formatResult = function (object) {
						return object.text ? object.text : object.firstName + ' ' + object.lastName + ' ' + object.email;
					};
					break;
			}
			delete options.format;
		}

		if (!_.isUndefined(options.urlRoot) && _.isString(options.urlRoot)) {
			options = _.extend(options, {
				id: function (object) {
					/* eslint no-underscore-dangle: 0  */
					return object.id || object._id;
				},
				ajax: {
					url: options.urlRoot + '/select/fetch',
					dataType: 'jsonp',
					quietMillis: 150,
					data: function (term) {
						return {
							q: term
						};
					},
					results: function (data) {
						if (options.addUrl) {
							data.push({
								id: -1,
								text: '<span class="fa fa-plus"></span> <a href="#">' + i18n.get('add') + '</a>'
							});
						}
						return {
							results: data
						};
					}
				}
			});
			delete options.urlRoot;
		}

		var label = $el.closest('.form-group').find('label').first(),
			handler = function () {
				if (!$el.closest('.group').hasClass('hidden')) {
					$el.select2('open');
				}
			},
			result = $el.select2(options).data('select2');

		result.onSelect = (function (onSelect) {
			return function (data) {
				if (data.id === -1) {
					$el.select2('destroy');
					eventBus.trigger('router:navigate', options.addUrl, true);
				} else {
					return onSelect.apply(this, arguments);
				}
			};
		}(result.onSelect));

		label.off('click', handler).on('click', handler);

		return result;
	};
});
