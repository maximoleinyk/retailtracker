define(function (require) {
    'use strict';

    var Marionette = require('marionette'),
        Backbone = require('backbone'),
        _ = require('underscore'),
        dataBinding = require('app/common/dataBinding'),
        eventBus = require('cs!app/common/eventBus'),
        routeToLink = {},
        requestCount = 0;

    return function (object) {
        var proto = object.prototype;

        return {

            eventBus: eventBus,

            constructor: function () {
                this.listenTo(this, 'before:render', this.bindData, this);
                this.listenTo(this, 'render', this.addEvents, this);
                this.listenTo(this, 'show', this.handleDataAttributes, this);
                this.listenTo(this, 'close', this.removeEvents, this);

                this.listenTo(this.eventBus, 'http:request:start', this.handleStartRequest, this);
                this.listenTo(this.eventBus, 'http:request:stop', this.handleStopRequest, this);
                this.listenTo(this.eventBus, 'open:page', this.openPage, this);

                this.addValidationModule();

                proto.constructor.apply(this, arguments);
            },

            handleStartRequest: function () {
                requestCount++;
                this.$el.find('[data-auto-disable]').attr('disabled', true);
            },

            handleStopRequest: function () {
                requestCount--;
                if (!requestCount) {
                    this.$el.find('[data-auto-disable]').removeAttr('disabled');
                }
            },

            openPage: function () {
                _.each(routeToLink, function (a, regexp) {
                    var regExp = new RegExp(regexp),
                        fragment = '/' + Backbone.history.fragment.replace(0, Backbone.history.fragment.indexOf('/'), '');

                    Backbone.$(a).removeClass('selected');

                    if (regExp.test(fragment)) {
                        a.addClass('selected');
                    }
                });
            },

            addValidationModule: function () {
                var self = this;

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
                }
            },

            addEvents: function () {
                var self = this;

                this.$el.find('form').on('submit', function (e) {
                    var $el = Marionette.$(this),
                        methodName = $el.attr('data-submit');

                    if (typeof self[methodName] === 'function') {
                        self[methodName](e);
                    }
                });

                this.$el.on('click', '[data-click]', function (e) {
                    e.preventDefault();
                    e.stopPropagation();

                    self[Backbone.$(e.currentTarget).data('click')](e);
                });
            },

            removeEvents: function () {
                this.$el.off('click', '[data-click]');
            },

            bindData: function () {
                dataBinding.bind(this);
            },

            handleDataAttributes: function () {
                var self = this,
                    attributesMap = {
                        autofocus: function ($el) {
                            if ($el.data('select2')) {
                                return $el.data('select2').select2('focus');
                            } else {
                                $el.focus();
                            }
                        },
                        'data-hide': function ($el) {
                            $el.addClass('hidden').removeAttr('data-hide');
                        },
                        'data-catch-url': function ($el) {
                            var route = $el.data('catch-url');
                            if (!route) {
                                route = $el.attr('href');
                            } else if (route === '/') {
                                route = 'root';
                            }
                            route = route.replace(new RegExp('^' + Backbone.history.root ? Backbone.history.root : ''), '');
                            routeToLink[route] = $el;
                        },
                        'data-id': function ($el) {
                            var name = $el.attr('data-id'),
                                ui = Marionette.getOption(self, 'ui');

                            if (!_.isObject(ui)) {
                                self.ui = {};
                            }

                            self.ui['$' + name] = $el;
                        }
                    };

                _.each(attributesMap, function (callback, attribute) {
                    callback(this.$el.find('[' + attribute + ']'), this);
                }, this);
            }
        }
    };

});