define(function (require) {
    'use strict';

    var rivets = require('rivets'),
        Marionette = require('marionette'),
        Backbone = require('backbone'),
        _ = require('underscore');

    if (typeof String.prototype.trim !== 'function') {
        String.prototype.trim = function () {
            return this.replace(/^\s+|\s+$/g, '');
        };
    }

    rivets.configure({
        prefix: 'data',
        templateDelimiters: [ '[', ']' ]
    });

    rivets.adapters['.'] = {
        subscribe: function (obj, keypath, callback) {
            if (!obj || !keypath || !obj.on) {
                return;
            }
            obj.on('change:' + keypath, callback);
        },
        unsubscribe: function (obj, keypath, callback) {
            if (!obj || !keypath || !obj.off) {
                return;
            }
            obj.off('change:' + keypath, callback);
        },
        read: function (obj, keypath) {
            if (!obj || !keypath) {
                return;
            }
            return obj.get ? obj.get(keypath) : obj[keypath];
        },
        publish: function (obj, keypath, value) {
            if (!obj || !keypath) {
                return;
            }

            if (typeof value === 'string') {
                value = value.trim();
                // when we set the numeric value from the input it has a string type
                // i.e. "32", "2.3" etc. Hence why we need to parse number from string
                // into its original type to avoid further inconsistencies with raw JSON
                if (value) {
                    // heading plus sign is needed for parsing numeric values (including
                    // those with floating point) and string concatenation is needed
                    // because: NaN === NaN -> false. But we also should skip values
                    // which was written with explicit specifying of leading zeros e.g. "000001"
                    // we have about 16 digits of precision so we also need to validate this
                    value = (+value + '' === 'NaN') ? value : (/^0+\d+/.test(value)) ? value : (value.length > 16) ? value : +value;
                }
            }

            return obj.set ? obj.set(keypath, value) : obj[keypath] = value;
        }
    };

    function bind(view, bindings) {
        bindings = bindings || {
            model: view.model
        };
        view.rv = rivets.bind(view.$el, bindings);
    }

    function unbind(view) {
        if (view.rv) {
            view.rv.unbind();
        }
    }

    var listeners = {
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
        viewConstructor = Marionette.View.prototype.constructor;

    Marionette.View.prototype.constructor = function () {
        var self = this,
            routeToLink = {};

        this.handleActions = _.bind(function (e) {
            e.preventDefault();
            e.stopPropagation();

            this[Backbone.$(e.currentTarget).data('action')](e);
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
            if (this.binding) {
                switch (typeof this.binding) {
                    case 'object':
                        return bind(this, this.binding);
                    case 'function':
                        return bind(this, this.binding.call(this));
                    default:
                        return bind(this);
                }
            }
            this.$el.find('[data-catch-url]').each(function () {
                var $el = Backbone.$(this),
                    route = $el.data('catch-url');
                if (!route) {
                    route = $el.attr('href');
                } else if (route === '/') {
                    route = 'root';
                }
                route = route.replace(new RegExp('^' + Backbone.history.root), '');
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
        }, this);

        this.listenTo(this, 'show', function () {
            _.each(listeners, function (callback, attribute) {
                callback(this.$el.find('[' + attribute + ']'), this);
            }, this);
        }, this);

        this.listenTo(this, 'close', function () {
            if (this.binding) {
                return unbind(this);
            }
            this.$el.off('click', '[data-click]', this.handleActions);
        }, this);

        this.listenTo(this.eventBus, 'open:page', function () {
            _.each(routeToLink, function (link) {
                Backbone.$(link).removeClass('selected');
            });
            _.each(routeToLink, function (a, regexp) {
                if (new RegExp(regexp).test('/' + Backbone.history.fragment)) {
                    a.addClass('selected');
                }
            });
        });

        viewConstructor.apply(this, arguments);

        this.$el.on('click', '[data-click]', this.handleActions);
    };

});
