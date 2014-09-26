define(function (require) {

	var EditRow = require('./rows/editRow'),
		ButtonCell = require('./cells/buttonCell'),
		ViewCell = require('./cells/viewCell');

	return EditRow.extend({

		initialize: function (options) {
			options = options || {};
			options.state = 'edit';

			this.model = new this.options.items.model({});
			EditRow.prototype.initialize.apply(this, arguments);
		},

        discardChanges: function() {
            this.model.clear();
        },

		buildCustomCell: function (type, options) {
			var self = this;

			if (type === 'edit') {
				return new ButtonCell(_.extend(options, {
					template: require('hbs!./cells/buttons/createButton'),
					action: function () {
						var next = function (err) {
                            self.handle(err, function() {
                                self.model = new self.options.items.model({});
                                self.render();
                            });
						};
						if (self.options.onCreate) {
							return self.options.onCreate(self.model, next);
						}
						next();
					}
				}));
			} else {
				return new ViewCell(options);
			}
		},

		onRender: function () {
			var self = this;
			setTimeout(function () {
				self.first().activate();
			}, 0)
		}

	});

});
