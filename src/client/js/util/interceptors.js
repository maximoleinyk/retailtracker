define(function (require) {
    'use strict';

    var Marionette = require('marionette'),
        Backbone = require('backbone'),
        _ = require('underscore'),
        dataBinding = require('./dataBinding'),
        listeners = {
            autofocus: function (el) {
                if (el.data('select2')) {
                    return el.data('select2').select2('focus');
                } else {
                    el.focus();
                }
            },
            'data-hide': function (el) {
                el.addClass('hidden').removeAttr('data-hide');
            }
        },
        eventBus = require('util/eventBus'),
        viewConstructor = Marionette.View.prototype.constructor,
        routeToLink = {};

    Marionette.View.prototype.constructor = function () {
        var self = this,
            requestCount = 0;

        this.listenTo(this.eventBus, 'http:request:start', function () {
            requestCount++;
            self.$el.find('[data-auto-disable]').attr('disabled', true);
        });

        this.listenTo(this.eventBus, 'http:request:stop', function () {
            requestCount--;
            if (!requestCount) {
                self.$el.find('[data-auto-disable]').removeAttr('disabled');
            }
        });

        this.handleActions = _.bind(function (e) {
            e.preventDefault();
            e.stopPropagation();

            this[Backbone.$(e.currentTarget).attr('data-click')](e);
        }, this);

        this.validation = {
            reset: function () {
                var $wrapper = self.$el.find('[data-validation]')
                    .text('')
                    .closest('.form-group, .validation-group')
                    .removeClass('has-error');

                $wrapper.each(function () {
                    var $el = Backbone.$(this);
                    if ($el.data('hidden')) {
                        $el.addClass('hidden');
                        $el.removeData('hidden');
                    }
                });

                self.$el.find('[data-validation]').each(function () {
                    var $el = Backbone.$(this);
                    if ($el) {
                        $el.addClass('hidden');
                    }
                });
            },
            show: function (messages) {
                if (!_.isObject(messages)) {
                    return;
                }

                _.each(messages, function (value, key) {
                    var $el = self.$el.find('[data-validation="' + key + '"]').text(value),
                        $wrapper = $el.closest('.form-group, .validation-group').addClass('has-error');

                    if ($wrapper.hasClass('hidden')) {
                        $wrapper.data('hidden', 'true').removeClass('hidden');
                    }

                    $el.removeClass('hidden');
                });

                var firstErrorGroup = self.$el.find('.has-error').first();
                if (!firstErrorGroup.length) {
                    firstErrorGroup = self.$el.find('[autofocus]').closest('.form-group, .validation-group');
                }
                firstErrorGroup.find('input, select, textarea').focus();
            }
        };

        this.listenTo(this, 'render', function () {
            dataBinding.bind(this);
            this.$el.find('[data-catch-url]').each(function () {
                var $el = Backbone.$(this),
                    route = $el.data('catch-url');
                if (!route) {
                    route = $el.attr('href');
                } else if (route === '/') {
                    route = 'root';
                }
                route = route.replace(new RegExp('^' + Backbone.history.root ? Backbone.history.root : ''), '');
                routeToLink[route] = $el;
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
            this.$el.find('form').on('submit', function (e) {
                var $el = Marionette.$(this),
                    methodName = $el.attr('data-submit');

                if (typeof self[methodName] === 'function') {
                    self[methodName](e);
                }
            });
        }, this);

        this.listenTo(this, 'show', function () {
            _.each(listeners, function (callback, attribute) {
                callback(this.$el.find('[' + attribute + ']'), this);
            }, this);
        }, this);

        this.listenTo(this, 'close', function () {
            this.$el.off('click', '[data-click]', this.handleActions);
        }, this);

        this.listenTo(this.eventBus, 'open:page', function () {
            var fragment = Backbone.history.fragment;
            _.each(routeToLink, function (link) {
                Backbone.$(link).removeClass('selected');
            });
            _.each(routeToLink, function (a, regexp) {
                if (new RegExp(regexp).test('/' + fragment.replace(0, fragment.indexOf('/'), ''))) {
                    a.addClass('selected');
                }
            });
        });

        viewConstructor.apply(this, arguments);

        this.$el.on('click', '[data-click]', this.handleActions);
    };

    var navigateTo = function (route, options) {
        options = options || {trigger: true};
        this.eventBus.trigger('router:navigate', route, options);
    };

    Backbone.View.prototype.navigateTo = navigateTo;
    Backbone.Router.prototype.navigateTo = navigateTo;
    Marionette.Controller.prototype.navigateTo = navigateTo;

});
