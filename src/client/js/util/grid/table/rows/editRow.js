define(function (require) {

    var AbstractRow = require('./abstractRow'),
        ViewCell = require('../cells/viewCell'),
        InputCell = require('../cells/inputCell'),
        DateCell = require('../cells/dateCell'),
        BoolCell = require('../cells/boolCell'),
        NumberCell = require('../cells/numberCell'),
        SelectCell = require('../cells/selectCell'),
        AutoincrementCell = require('../cells/autoincrementCell'),
        ButtonCell = require('../cells/buttonCell');

    return AbstractRow.extend({

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
                default:
                    return this.buildCustomCell(type, options);
            }
        },

        buildCustomCell: function (type, options) {
            if (type === 'autoincrement') {
                return new AutoincrementCell(options);
            } else if (type === 'edit') {
                return new ButtonCell(_.extend(options, {
                    action: function (e) {
                        console.log('Save applied changed');
                    }
                }));
            } else {
                return new ViewCell(options);
            }
        }

    });

});
