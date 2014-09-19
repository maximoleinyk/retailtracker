define(function (require) {

    var AbstractRow = require('./abstractRow'),
        ViewCell = require('../cells/viewCell'),
        AutoincrementCell = require('../cells/autoincrementCell'),
        ButtonCell = require('../cells/buttonCell');

    return AbstractRow.extend({

        buildCellView: function (type, column, options) {
            switch (type) {
                case 'autoincrement':
                    return new AutoincrementCell(options);
                case 'edit':
                    return this.renderButtonCell(options);
                default:
                    return this.renderCustomCell(type, options);
            }
        },

        renderCustomCell: function(type, options) {
            if (type === 'autoincrement') {
                return new AutoincrementCell(options);
            } else {
                return new ViewCell(options);
            }
        },

        renderButtonCell: function(options) {
            var action;

            if (this.state === 'view') {
                action = function(e) {
                    console.log('Make row editable');
                };
            } else if (this.state === 'edit') {
                action = function(e) {
                    console.log('Save applied changed');
                };
            }

            return new ButtonCell(_.extend(options, {
                action: action
            }));
        }

    });

});
