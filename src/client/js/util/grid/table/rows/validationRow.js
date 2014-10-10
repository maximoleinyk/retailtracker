define(function (require) {

    var _ = require('underscore'),
        Marionette = require('marionette');

    return Marionette.ItemView.extend({

        template: require('hbs!./validationRow'),
        tagName: 'tr',
        className: 'validation',

        templateHelpers: function () {
            var self = this;
            return {
                errors: function () {
                    var result = [];
                    _.each(self.options.errors, function (value, key) {
                        result.push({
                            field: key,
                            value: value
                        });
                    });
                    return result;
                }
            };
        },

        activate: function (e) {
            e.preventDefault();

            var field = $(e.currentTarget).attr('data-field'),
                cellView = this.options.cellManager.getCell(field);

            if (cellView) {
                cellView.activate();
            }
        },

        highlightCells: function () {
            _.each(this.options.errors, function (value, field) {
                this.options.cellManager.getCell(field).invalid();
            }, this);
        },

        expandRow: function () {
            this.$el.children().first().attr('colspan', this.options.cellManager.size());
        },

        addValidationHandler: function(callback) {
            this.listenTo(this, 'validate', callback);
        },

        addListeners: function () {
            _.each(this.options.errors, function (value, field) {
                this.listenTo(this.options.model, 'change:' + field, function () {
                    this.options.cellManager.getCell(field).valid();
                    delete this.options.errors[field];
                    this.trigger('validate', _.isEmpty(this.options.errors));
                    this.render();
                }, this);
            }, this);
        },

        onRender: function () {
            if (_.isEmpty(this.options.errors)) {
                return this.close();
            }
            this.highlightCells();
            this.expandRow();
            this.addListeners();
        }

    });

});
