define(function (require) {

    var Marionette = require('marionette'),
        Header = require('./header'),
        Content = require('./content'),
        Footer = require('./footer');

    return Marionette.Layout.extend({

        template: require('hbs!./main'),

        regions: {
            header: '[data-id="thead"]',
            body: '[data-id="tbody"]',
            footer: '[data-id="tfoot"]'
        },

        onRender: function () {
            this.build();
        },

        buildHeader: function () {
            this.header.show(new Header({
                columns: this.options.columns
            }))
        },

        buildContent: function () {
            this.body.show(new Content({
                columns: this.options.columns,
                collection: this.options.collection
            }));
        },

        buildFooter: function () {
            this.footer.show(new Footer({
                columns: this.options.columns,
                items: this.options.collection
            }));
        },

        build: function () {
            this.buildHeader();
            this.buildContent();
            this.buildFooter();
        }

    });

});
