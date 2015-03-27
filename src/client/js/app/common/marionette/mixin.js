define(function (require) {
	'use strict';

	var Marionette = require('marionette'),
		Backbone = require('backbone'),
		_ = require('underscore'),
		dataBinding = require('app/common/dataBinding'),
		eventBus = require('cs!app/common/eventBus'),
		$ = require('jquery');

	return function (object) {
		var proto = object.prototype;

		return {

			eventBus: eventBus,

			constructor: function () {
				this.addEvents();
				proto.constructor.apply(this, arguments);
			},

			delegateEvents: function () {
				Marionette.View.prototype.delegateEvents.apply(this, arguments);
				Marionette.bindEntityEvents(this, this.eventBus, Marionette.getOption(this, 'appEvents'));
			},

			undelegateEvents: function () {
				Marionette.View.prototype.undelegateEvents.apply(this, arguments);
				Marionette.unbindEntityEvents(this, this.eventBus, Marionette.getOption(this, 'appEvents'));
			},

			addEvents: function () {
				this.listenTo(this, 'render', this.addBehaviours, this);
				this.listenTo(this, 'show', this.afterRender, this);
				this.listenTo(this, 'close', this.removeEvents, this);
				this.listenTo(this.eventBus, 'open:page', this.highlightSelectedLinks, this);
			},

			highlightSelectedLinks: function () {
				this.$el.find('[data-catch-url]').each(function () {
					var $el = Marionette.$(this),
						route = $el.data('catch-url');

					if (!route) {
						route = $el.attr('href');
					} else if (route === '/') {
						route = 'root';
					}

					var regExp = new RegExp(route.replace(new RegExp('^' + Backbone.history.root ? Backbone.history.root : ''), '')),
						fragment = '/' + Backbone.history.fragment.replace(0, Backbone.history.fragment.indexOf('/'), '');

					$el.removeClass('selected');

					if (regExp.test(fragment)) {
						$el.addClass('selected');
					}
				});
			},

			afterRender: function () {
				this.$el.find('[data-focus]').each(function () {
					var $el = Marionette.$(this);
					if ($el.data('select2')) {
						return $el.select2('focus');
					} else {
						$el.focus();
					}
				});
				this.$el.find('[data-optional]').each(function () {
					var $el = Marionette.$(this),
						message = $el.attr('data-optional'),
						$formGroup = $el.closest('.form-group'),
						$group = $el.closest('.group'),
						$a = $('<a href="#" class="optional-link">' + message + '</a>');

					if (!$el.val()) {
						$group.addClass('hidden');
						$formGroup.append($a);
						$a.on('focus click', function (e) {
							e.preventDefault();
							$a.remove();
							$group.removeClass('hidden');
							var $control = $group.find('.form-control');
							if ($control.data('select2')) {
								return $control.select2('focus');
							} else {
								$control.focus();
							}
						});
					}
				});
			},

			addBehaviours: function () {
				var self = this;

				this.$el.off('submit', 'form').on('submit', 'form', function (e) {
					var $el = Marionette.$(this),
						methodName = $el.attr('data-submit');

					if (typeof self[methodName] === 'function') {
						e.preventDefault();
						self[methodName](e);
					}
				});

				this.$el.off('click', '[data-click]').on('click', '[data-click]', function (e) {
					e.preventDefault();
					e.stopPropagation();

					self[Marionette.$(this).data('click')](e);
				});

				this.$el.find('[data-id]').each(function () {
					var $el = Marionette.$(this),
						name = $el.attr('data-id'),
						ui = Marionette.getOption(self, 'ui');

					if (!_.isObject(ui)) {
						self.ui = {};
					}

					self.ui['$' + name] = $el;
				});

				this.$el.find('[data-toggle="tooltip"]').tooltip();

				dataBinding.bind(this);
			},

			find: function () {
				return this.$el.find.apply(this.$el, arguments);
			},

			removeEvents: function () {
				this.$el.off('click', '[data-click]');
				this.$el.off('submit', 'form');
			},

			navigateTo: function (route, options) {
				options = options || {trigger: true};
				eventBus.trigger('router:navigate', route, options);
			},

			openPage: function (view, options) {
				options = options || {};
				eventBus.trigger('open:page', view, options);
			}
		};
	};

});
