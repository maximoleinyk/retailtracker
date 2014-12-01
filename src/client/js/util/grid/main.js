define(function (require) {

    var Marionette = require('marionette'),
        Table = require('./table/main'),
        _ = require('underscore');

    return Marionette.Layout.extend({

        template: require('hbs!./main'),
        className: 'grid',

        regions: {
            header: '.header',
            content: '.body',
            footer: '.footer'
        },

        initialize: function (options) {
            options = options || {};

            this.editable = options.editable || void(0);
            this.numerable = options.numerable || false;
            this.withoutHeader = options.withoutHeader || false;
            this.isActionCellVisible = options.isActionCellVisible || function () {
                return true;
            };
        },

        onRender: function () {
            this.obtainColumns();
            this.build();
        },

        obtainColumns: function () {
            if (this.numerable) {
                this.options.columns.unshift({
                    field: 'numerable',
                    type: 'autoincrement',
                    title: '#'
                });
            }
            if (_.isObject(this.editable)) {
                this.options.columns.push({
                    field: 'editable',
                    type: 'edit',
                    title: ''
                });
            }
        },

        buildHeader: function () {
//            this.header.show(new Header({
//                columns: this.options.columns
//            }))
        },

        buildContent: function () {
            this.content.show(new Table({
                columns: this.options.columns,
                collection: this.options.collection,
                numerable: this.numerable,
                editable: this.editable,
                withoutHeader: this.withoutHeader,
                defaultEmptyText: this.options.defaultEmptyText,
                skipInitialAutoFocus: this.options.skipInitialAutoFocus,
                isActionCellVisible: this.isActionCellVisible
            }));
        },

        buildFooter: function () {
//            this.footer.show(new Footer({
//                columns: this.options.columns,
//                items: this.options.collection
//            }));
        },

        build: function () {
            this.buildHeader();
            this.buildContent();
            this.buildFooter();
        }

    });

});
