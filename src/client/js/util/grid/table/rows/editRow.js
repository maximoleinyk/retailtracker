define(function (require) {

    var $ = require('jquery'),
        AbstractRow = require('./abstractRow'),
        ViewCell = require('../cells/viewCell'),
        InputCell = require('../cells/inputCell'),
        DateCell = require('../cells/dateCell'),
        BoolCell = require('../cells/boolCell'),
        NumberCell = require('../cells/numberCell'),
        SelectCell = require('../cells/selectCell'),
        EmailCell = require('../cells/emailCell'),
        AutoincrementCell = require('../cells/autoincrementCell'),
        DropdownButtonCell = require('../cells/dropdownButtonCell'),
        _ = require('underscore');

    return AbstractRow.extend({

        initialize: function () {
            AbstractRow.prototype.initialize.apply(this, arguments);
            this.addListeners();
        },

        addListeners: function () {
            this.listenTo(this, 'render', function () {
                $(document).on('keyup', _.bind(this.handleKeyUp, this));
            }, this);
            this.listenTo(this, 'close', function () {
                $(document).off('keyup', _.bind(this.handleKeyUp, this));
            }, this);
        },

        handleKeyUp: function (e) {
            switch (e.keyCode) {
                // ESC
                case 27:
                    this.discardChanges();
                    break;
            }
        },

        disableInputs: function () {
            _.each(this.options.columns, function (column) {
                this.getCell(column.field).disable();
            }, this);
        },

        enableInputs: function () {
            _.each(this.options.columns, function (column) {
                this.getCell(column.field).enable();
            }, this);
        },

        discardChanges: function (silent) {
            var self = this,
                next = function () {
                    if (!self.valid) {
                        self.validationRow.close();
                        self.valid = true;
                        self.$el.removeClass('invalid');
                    }
                    !silent && self.changeState('view');
                };

            if (this.options.editable.onCancel) {
                this.options.editable.onCancel(self.model, next);
            } else {
                next();
            }
        },

        buildCellView: function (type, column, options) {
            switch (type) {
                case 'string':
                    return new InputCell(options);
                case 'date':
                    return new DateCell(options);
                case 'number':
                    return new NumberCell(options);
                case 'boolean':
                    return new BoolCell(options);
                case 'select':
                    return new SelectCell(options);
                case 'email':
                    return new EmailCell(options);
                default:
                    return this.buildCustomCell(type, column, options);
            }
        },

        buildCustomCell: function (type, column, options) {
            var self = this;

            if (type === 'autoincrement') {
                return new AutoincrementCell(options);
            } else if (type === 'edit') {
                return new DropdownButtonCell(_.extend(options, {
                    buttonClassName: 'btn-default',
                    buttonIcon: 'fa-save',
                    actions: [
                        {
                            label: 'Отменить',
                            methodName: 'onCancel'
                        }
                    ],
                    onCancel: function () {
                        self.discardChanges();
                    },
                    onAction: function () {
                        var next = function (err) {
                            self.enableInputs();
                            self.validate(err, function () {
                                self.changeState('view');
                            });
                        };
                        self.disableInputs();
                        if (self.options.editable.onSave) {
                            return self.options.editable.onSave(self.model, next);
                        }
                        next();
                    }
                }));
            } else {
                return new ViewCell(options);
            }
        }

    });

});
