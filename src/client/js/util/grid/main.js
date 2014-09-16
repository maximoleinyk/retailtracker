define(function (require) {

    var Marionette = require('marionette'),
        Table = require('./table/main'),
        _ = require('underscore');

    return Marionette.Layout.extend({

        template: require('hbs!./main'),
        className: 'grid',

        regions: {
            header: 'header',
            content: 'section',
            footer: 'footer'
        },

        onRender: function () {
            this.obtainColumns();
            this.build();
        },

        obtainColumns: function() {
            this.columns = _.map(this.options.columns, function (value, key) {
                return _.extend(value, {
                    field: key
                });
            });

            if (this.options.numerable) {
                this.columns.unshift({
                    field: 'numerable',
                    type: 'autoincrement',
                    title: '#'
                })
            }
        },

        buildHeader: function () {
//            this.header.show(new Header({
//                columns: this.options.columns
//            }))
        },

        buildContent: function () {
            this.content.show(new Table({
                columns: this.columns,
                collection: this.options.collection,
                numerable: this.options.numerable
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
