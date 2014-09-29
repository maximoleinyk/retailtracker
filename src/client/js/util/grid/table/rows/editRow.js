define(function (require) {

	var AbstractRow = require('./abstractRow'),
		ViewCell = require('../cells/viewCell'),
		InputCell = require('../cells/inputCell'),
		DateCell = require('../cells/dateCell'),
		BoolCell = require('../cells/boolCell'),
		NumberCell = require('../cells/numberCell'),
		SelectCell = require('../cells/selectCell'),
		AutoincrementCell = require('../cells/autoincrementCell'),
		DropdownButtonCell = require('../cells/dropdownButtonCell');

	return AbstractRow.extend({

		initialize: function () {
			AbstractRow.prototype.initialize.apply(this, arguments);
			this.addKeyBindings();
		},

		addKeyBindings: function () {
			var self = this,
				keyHandler = function (e) {
					if (e.keyCode !== 27) {
						return;
					}
					self.discardChanges();
					self.render(self.getRowIndex());
				};

			this.listenTo(this, 'render', function () {
				$(document).on('keydown', keyHandler);
			});
			this.listenTo(this, 'close', function () {
				$(document).off('keydown', keyHandler);
			});
		},

		discardChanges: function () {
			this.model.revert();
			this.changeState('view');
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
				default:
					return this.buildCustomCell(type, options);
			}
		},

		buildCustomCell: function (type, options) {
			var self = this;

			if (type === 'autoincrement') {
				return new AutoincrementCell(options);
			} else if (type === 'edit') {
				return new DropdownButtonCell(_.extend(options, {
					buttonClassName: 'btn-success',
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
							self.handle(err, function () {
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
