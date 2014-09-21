define(function (require) {

    var AbstractRow = require('./abstractRow'),
        ViewCell = require('../cells/viewCell'),
        AutoincrementCell = require('../cells/autoincrementCell'),
        ButtonCell = require('../cells/buttonCell');

    return AbstractRow.extend({

        buildCellView: function (type, column, options) {
			var self = this;

            switch (type) {
                case 'autoincrement':
                    return new AutoincrementCell(options);
                case 'edit':
                    return new ButtonCell(_.extend(options, {
						template: require('hbs!../cells/buttons/updateButton'),
                        action: function () {
							self.changeState('edit');
                        }
                    }));
                default:
                    return new ViewCell(options);
            }
        }

    });

});
