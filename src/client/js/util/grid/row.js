define(function (require) {

    var Marionette = require('marionette'),
        ViewCell = require('./cells/viewCell'),
        TextCell = require('./cells/textCell'),
        DateCell = require('./cells/dateCell'),
        BoolCell = require('./cells/boolCell'),
        NumberCell = require('./cells/numberCell'),
        ActionCell = require('./cells/actionCell');

    return Marionette.CollectionView.extend({

        template: require('hbs!./row'),
        itemView: true,

        initialize: function (options) {
            this.editable = options.editable || false;
            this.initializeCollection();
        },

        initializeCollection: function () {
            var columns = _.map(this.options.columns, function (value, key) {
                return _.extend(value, {
                    field: key
                });
            });

            if (this.editable) {
                columns.push({
                    field: 'editable',
                    type: 'action'
                });
            }

            this.collection = new Backbone.Collection(columns);
        },

        buildItemView: function (column, itemView, itemViewOptions) {
            itemViewOptions = itemViewOptions || {};

            var type = column.get('type') || 'view',
                options = _.extend(itemViewOptions, {
                    model: this.model,
                    meta: column
                });

            switch (type) {
                case 'string':
                    return new TextCell(options);
                case 'date':
                    return new DateCell(options);
                case 'number':
                    return new NumberCell(options);
                case 'boolean':
                    return new BoolCell(options);
                case 'action':
                    return new ActionCell(options);
                default:
                    return new ViewCell(options);
            }
        }

    });

});