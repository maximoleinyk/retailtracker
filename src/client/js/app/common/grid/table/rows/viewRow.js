define(function (require) {
	'use strict';

	var AbstractRow = require('./abstractRow'),
		ViewCell = require('../cells/viewCell'),
		AutoincrementCell = require('../cells/autoincrementCell'),
		ButtonCell = require('../cells/buttonCell'),
		DropdownButtonCell = require('../cells/dropdownButtonCell'),
		_ = require('underscore');

	return AbstractRow.extend({

		buildCellView: function (type, column, options) {
			var self = this;

			switch (type) {
				case 'autoincrement':
					return new AutoincrementCell(options);
				case 'button':
					if (options.isActionCellVisible && options.isActionCellVisible(options.model)) {
						return new ButtonCell(options);
					}
					return new ViewCell(options);
				case 'edit':
					if (options.isActionCellVisible && options.isActionCellVisible(options.model)) {
						if (this.options.editableCell) {
							return new this.options.editableCell(options);
						} else {
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
						}
					}
					return new ViewCell(options);
				default:
					return new ViewCell(options);
			}

		}

	});

});
