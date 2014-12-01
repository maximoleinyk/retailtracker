define(function (require) {

    var EditRow = require('./rows/editRow'),
        ButtonCell = require('./cells/buttonCell'),
        ViewCell = require('./cells/viewCell'),
        _ = require('underscore');

    return EditRow.extend({

        initialize: function (options) {
            options = options || {};
            options.state = 'edit';

            this.model = new this.options.items.model({});
            EditRow.prototype.initialize.apply(this, arguments);
        },

        discardChanges: function () {
            this.model.clear();
        },

        buildCustomCell: function (type, column, options) {
            var self = this;

            if (type === 'edit') {
                return new ButtonCell(_.extend(options, {
                    template: require('hbs!./cells/buttons/createButton'),
                    action: function () {
                        var next = function (err) {
                            self.options.skipInitialAutoFocus = false;
                            self.enableInputs();
                            self.validate(err, function () {
                                self.model = new self.options.items.model({});
                                self.render();
                            });
                        };
                        self.disableInputs();
                        if (self.options.editable.onCreate) {
                            return self.options.editable.onCreate(self.model, next);
                        }
                        next();
                    }
                }));
            } else if (type === 'custom') {
                var CustomCell = column.get('cell');
                return new CustomCell(_.extend(options, column.get('options')));
            } else {
                return new ViewCell(options);
            }
        },

        onRender: function () {
            if (this.options.skipInitialAutoFocus) {
                return;
            }

            var self = this;
            _.defer(function () {
                self.first().activate();
            });
        }

    });

});
