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
                    return new ButtonCell(_.extend(options, {
                        action: function (e) {
                            console.log('Make row editable');
                        }
                    }));
                default:
                    return new ViewCell(options);
            }
        }

    });

});
