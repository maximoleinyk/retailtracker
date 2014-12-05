define(function (require) {
    'use strict';

    var AbstractCell = require('./abstractCell'),
        _ = require('underscore');

    return AbstractCell.extend({

        template: require('hbs!./inputCell.hbs'),

        ui: {
            $input: 'input'
        },

        events: {
            'change @ui.$input': 'updateModel'
        },

        onRender: function () {
            AbstractCell.prototype.onRender.apply(this, arguments);
            this.bindInputEvents();
        },

        bindInputEvents: function () {
            this.ui.$input.on('change', _.bind(function () {
                var field = this.options.column.get('field'),
                    value = this.ui.$input.val();

                this.model.set(field, value);
            }, this));
        },

        templateHelpers: function () {
            return {
                type: _.bind(this.getType, this),
                name: _.bind(this.getName, this),
                placeholder: _.bind(this.getPlaceholder, this)
            };
        },

        updateModel: function () {
            var property = this.options.column.get('field'),
                value = this.ui.$input.val();

            this.model.set(property, value);
        },

        appendValue: function (value) {
            this.ui.$input.val(value);
        },

        getPlaceholder: function () {
            return this.options.column.get('placeholder');
        },

        getName: function () {
            return this.options.column.get('field');
        },

        getType: function () {
            return 'text';
        },

        activate: function () {
            this.ui.$input.focus().select();
        },

        disable: function () {
            this.ui.$input.attr('disabled', true);
        },

        enable: function () {
            this.ui.$input.removeAttr('disabled');
        }

    });

});
