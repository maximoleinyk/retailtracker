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
                model = view[$el.data().bind];

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
        var flattenAttributes = {},
            $bindings = view.$('[data-bind]');

        // TODO Should be able to replace this method shortly, now that we have NestedModel
        var obtainAttributes = function (set, depth) {
            depth = depth || '';

            // set param has a simple type i.e. set = array[0] = 'sample'
            // so flattenAttributes['array[0]'] = 'sample'
            if (!_.isObject(set) && !_.isArray(set)) {
                flattenAttributes[depth] = set;
                return;
            }

            _.each(set, function (value, key) {
                if (_.isArray(value)) {
                    _.each(value, function (v, i) {
                        obtainAttributes(v, depth ? depth + '.' + key + '[' + i + ']' : key + '[' + i + ']');
                    });
                } else if (_.isObject(value)) {
                    // TODO Necessary PT-X hack: Account for an attribute being a Model
                    // (This is only required until PT-X fully drops BackboneRelational)
                    if (value && typeof value.toJSON === 'function') {
                        value = value.toJSON();
                    }
                    obtainAttributes(value, depth ? depth + '.' + key : key);
                } else {
                    flattenAttributes[depth ? depth + '.' + key : key] = value;
                }
            });
        };

        // recursion is always bad this could be changed in future for iterative implementation
        obtainAttributes(view.model.attributes);

        _.each(flattenAttributes, function (value, key) {
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