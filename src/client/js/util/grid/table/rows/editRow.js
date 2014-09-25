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
			var self = this;

            if (type === 'autoincrement') {
                return new AutoincrementCell(options);
            } else if (type === 'edit') {
                return new ButtonCell(_.extend(options, {
					template: require('hbs!../cells/buttons/saveButton'),
                    action: function () {
						var next = function(err) {
                            self.handle(err, function() {
                                self.changeState('view');
                            });
						};
						if (self.options.onSave) {
							return self.options.onSave(self.model, next);
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
