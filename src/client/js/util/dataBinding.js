define(function (require) {
    'use strict';

    var $ = require('jquery'),
        _ = require('underscore'),
        Model = require('cs!../app/common/mongoModel');

    function canBeChecked(el) {
        return el.tagName === 'INPUT' && (el.type === 'checkbox' || el.type === 'radio');
    }

    function getDomValue($el) {
        var value = $el.val();

        if (canBeChecked($el.get(0))) {
            value = $el.prop('checked') ? value : null;
            value = value === 'on' ? true : value; // `on` is the value for a checked checkbox with no set value.
        }

        return value;
    }

    function setDomValue($el, value) {
        if (canBeChecked($el.get(0))) {
            return $el.prop('checked', !!value);
        }

        $el.val(value);
    }

    function setModelValue(model, $el) {
        var key = $el.attr('name');
        return model.set(key, getDomValue($el), {
            changeFromBinding: true
        });
    }

    function listenToInput(view) {
        view.$el.on('input change', '[data-bind]', function (e) {
            var $el = $(e.target),
                model = view[$el.data().bind || 'model'];

            setModelValue(model, $el);
        });
    }

    function insertValues(attrs, bindings) {
        _.each(attrs, function (value, key) {
            var $inputs = bindings.filter('[name="' + key + '"]');
            $inputs.each(function () {
                setDomValue($(this), value);
            });
            bindings.filter('[data-text="' + key + '"]').text(value);
        });
    }

    function listenToModel(view) {
        view.listenTo(view.model, 'change', function (model, options) {
            options = options || {};

            var attrs = view.model.changedAttributes();

            // we may only update data-text element in case of changing model's attribute
            if (options.changeFromBinding) {
                var $texts = view.$('[data-text]');
                _.each(attrs, function (value, key) {
                    var $tags = $texts.filter('[data-text="' + key + '"]');
                    $tags.each(function () {
                        $(this).text(value);
                    });
                });
            } else {
                insertValues(attrs, view.$('[data-bind]'));
            }
        });

        view.listenTo(view.model, 'request validate', function () {
            view.$('[data-disable-on]').attr('disabled', true);
        });

        view.listenTo(view.model, 'sync invalid', function () {
            view.$('[data-disable-on]').removeAttr('disabled');
        });
    }

    function listenToValidation(view) {
        view.listenTo(view.model, 'validate', function () {
            var warnings = view.model.get('warning'),
                errors = view.model.get('error'),
                $bindings = view.$('[data-bind]');

            if (warnings) {
                _.each(warnings, function (value, key) {
                    $bindings.filter('[data-validate="' + key + '"]').text('').closest('.form-group').removeClass('has-warning');
                });
            }

            if (errors) {
                _.each(errors, function (value, key) {
                    $bindings.filter('[data-validate="' + key + '"]').text('').closest('.form-group').removeClass('has-error');
                });
            }

            view.model.unset('warning');
            view.model.unset('error');
        });

        view.listenTo(view.model, 'invalid', function () {
            var warnings = view.model.get('warning'),
                errors = view.model.get('error'),
                $bindings = view.$('[data-bind]');

            if (warnings) {
                _.each(warnings, function (value, key) {
                    $bindings.filter('[data-validate="' + key + '"]').text(value.join(', ')).closest('.form-group').addClass('has-warning');
                });
            }

            if (errors) {
                _.each(errors, function (value, key) {
                    $bindings.filter('[data-validate="' + key + '"]').text(value.join(', ')).closest('.form-group').addClass('has-error');
                });
            }
        });
    }

    function setInitialValues(view) {
        var attrs = view.model.attributes,
            $bindings = view.$('[data-bind]');

        _.each(attrs, function (value, key) {
            var $inputs = $bindings.filter('[name="' + key + '"]');
            $inputs.each(function () {
                var $el = $(this);

                if (canBeChecked($el.get(0))) {
                    if ($el.is(':radio')) {
                        // we should check name and value of the radio buttons
                        if ($el.val() === value) {
                            $el.prop('checked', !!value);
                        }
                    } else {
                        return $el.prop('checked', !!value);
                    }
                } else {
                    $el.val(value);
                }
            });

            $bindings.filter('[data-text="' + key + '"]').text(value);
        });
    }

    return  {
        bind: function (view) {
            if (!view.model) {
                view.model = new Model();
            }
            setInitialValues(view);
            listenToModel(view);
            listenToInput(view);
            listenToValidation(view);
        }
    };
});