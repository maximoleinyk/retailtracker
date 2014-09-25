define(function (require) {

    var Backbone = require('backbone'),
        Marionette = require('marionette'),
        ValidationRow = require('./validationRow');

    return Marionette.CollectionView.extend({

        template: require('hbs!./abstractRow'),
        itemView: true,
        tagName: 'tr',

        initialize: function (options) {
            this.state = options.state || false;
            this.collection = new Backbone.Collection(this.options.columns);
            this.valid = true;
        },

        handle: function (err, callback) {
            if (!err) {
                return callback();
            } else if (!this.valid) {
                return;
            }

            var self = this,
                row = new ValidationRow({
                    errors: err,
                    cellManager: this,
                    model: this.model
                });

            this.valid = false;
            row.addValidationHandler(function (valid) {
                self.valid = valid;
            });

            return this.$el.after(row.render().el);
        },

        changeState: function (state) {
            this.state = state;
            this.trigger('change:state', state, this, this.model);
        },

        addStateChangeHandler: function(callback) {
            this.listenTo(this, 'change:state', callback);
        },

        render: function (index) {
            this.rowIndex = index;
            return Marionette.CollectionView.prototype.render.apply(this, arguments);
        },

        size: function() {
            return this.options.columns.length;
        },

        getRowIndex: function () {
            return this.rowIndex;
        },

        getCellIndex: function (field) {
            var index = -1;

            this.collection.each(function (model, i) {
                if (model.get('field') === field) {
                    index = i;
                    return false;
                }
            });

            return index;
        },

        first: function () {
            return this.children.findByIndex(this.options.numerable ? 1 : 0);
        },

        getCell: function (field) {
            var index = this.getCellIndex(field);

            return this.children.findByIndex(index);
        },

        next: function (column) {
            var index = this.getCellIndex(column.get('field'));

            return this.children.findByIndex((this.collection.length - 1 === index) ? index : index + 1);
        },

        prev: function (column) {
            var index = this.getCellIndex(column.get('field')),
                allowedIndex = this.options.numerable ? 1 : 0;

            return this.children.findByIndex((index === allowedIndex) ? allowedIndex : --index);
        },

        buildItemView: function (column, itemView, itemViewOptions) {
            itemViewOptions = itemViewOptions || {};

            var type = column.get('type') || 'view',
                options = _.extend(itemViewOptions, {
                    model: this.model,
                    collection: this.options.items,
                    column: column,
                    cellManager: this
                });

            return this.buildCellView(type, column, options)
        },

        buildCellView: function (type, column, options) {
            throw 'Method not implemented';
        },

        removeItem: function (model) {
        }

    });

});