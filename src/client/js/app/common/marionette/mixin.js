define(function (require) {
    'use strict';

    var Marionette = require('marionette'),
        Backbone = require('backbone'),
        _ = require('underscore'),
        dataBinding = require('app/common/dataBinding'),
        eventBus = require('cs!app/common/eventBus');

    return function (object) {
        var proto = object.prototype;

        return {

            eventBus: eventBus,

            constructor: function () {
                this.addEvents();
                this.addValidationModule();
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
                            firstErrorGroup = self.$el.find('[data-focus]').closest('.form-group, .validation-group');
                        }
                        firstErrorGroup.find('input, select, textarea').focus();
                    }
                };
            },

            addEvents: function () {
                this.listenTo(this, 'close', this.removeEvents, this);
				this.listenTo(this, 'render', this.addDataBinding, this);
                this.listenTo(this, 'render', this.addBehaviours, this);
                this.listenTo(this, 'show', this.addAutofocusBehaviour, this);
                this.listenTo(this.eventBus, 'open:page', this.highlightSelectedLinks, this);
            },

            addAutofocusBehaviour: function () {
                this.$el.find('[data-focus]').each(function () {
                    var $el = Marionette.$(this);
                    if ($el.data('select2')) {
                        return $el.data('select2').select2('focus');
                    } else {
                        $el.focus();
                    }
                });
            },

            addBehaviours: function () {
                var self = this,
                    attributesMap = {
                        'data-hide': function ($el) {
                            $el.addClass('hidden').removeAttr('data-hide');
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

                self.$el.on('submit', 'form', function (e) {
                    var $el = Marionette.$(this),
                        methodName = $el.attr('data-submit');

                    if (typeof self[methodName] === 'function') {
                        self[methodName](e);
                    }
                });

                self.$el.on('click', '[data-click]', function (e) {
                    e.preventDefault();
                    e.stopPropagation();

                    self[Marionette.$(this).data('click')](e);
                });

                _.each(attributesMap, function (callback, attribute) {
                    self.$el.find('[' + attribute + ']').each(function () {
                        callback(Marionette.$(this), self);
                    });
                }, self);
            },

            removeEvents: function () {
                this.$el.off('click', '[data-click]');
                this.$el.off('submit', 'form');
            },

            addDataBinding: function () {
                dataBinding.bind(this);
            },

            navigateTo: function (route, options) {
                options = options || {trigger: true};
                eventBus.trigger('router:navigate', route, options);
            }
        };
    };

});
