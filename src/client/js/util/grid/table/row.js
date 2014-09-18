define(function (require) {

    var Backbone = require('backbone'),
        Marionette = require('marionette'),
        ViewCell = require('./cells/viewCell'),
        InputCell = require('./cells/inputCell'),
        DateCell = require('./cells/dateCell'),
        BoolCell = require('./cells/boolCell'),
        NumberCell = require('./cells/numberCell'),
        SelectCell = require('./cells/selectCell'),
        AutoincrementCell = require('./cells/autoincrementCell');

    return Marionette.CollectionView.extend({

        template: require('hbs!./row'),
        itemView: true,
        tagName: 'tr',

        initialize: function (options) {
            this.state = options.state || false;
            this.collection = new Backbone.Collection(this.options.columns);
        },

        next: function (column) {
            var index = -1;

            this.collection.each(function (model, i) {
                if (model.get('field') === column.get('field')) {
                    index = i;
                    return false;
                }
            });

            return this.children.findByIndex((this.collection.length - 1 === index) ? index : index + 1);
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

            if (this.state === 'edit') {
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
                        return this.buildCustomItemView(type, column, options);
                }
            } else {
                return new ViewCell(options);
            }
        },

        buildCustomItemView: function (type, column, options) {
            switch (type) {
                case 'autoincrement':
                    return new AutoincrementCell(options);
                default:
                    return new ViewCell(options);
            }
        }

    });

});
