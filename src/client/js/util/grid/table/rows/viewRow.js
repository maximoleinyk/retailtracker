define(function (require) {

	var AbstractRow = require('./abstractRow'),
		ViewCell = require('../cells/viewCell'),
		AutoincrementCell = require('../cells/autoincrementCell'),
		DropdownButtonCell = require('../cells/dropdownButtonCell'),
        _ = require('underscore');

	return AbstractRow.extend({

		buildCellView: function (type, column, options) {
			var self = this;

			switch (type) {
				case 'autoincrement':
					return new AutoincrementCell(options);
				case 'edit':
					return new DropdownButtonCell(_.extend(options, {
						buttonClassName: 'btn-default',
						buttonIcon: 'fa-pencil',
						actions: [
							{
								label: 'Удалить',
								methodName: 'onDelete'
							}
						],
						onDelete: function () {
							var next = function (err) {
								self.validate(err, function () {
									self.removeItem(self.model);
								});
							};
							if (self.options.editable.onDelete) {
								return self.options.editable.onDelete(self.model, next);
							}
							next();
						},
						onAction: function () {
							self.changeState('edit');
						}
					}));
				default:
					return new ViewCell(options);
			}
		}

	});

});
