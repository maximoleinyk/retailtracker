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
                model: this.model,
                columns: this.options.columns,
                collection: this.options.collection
            }))
        },

        buildContent: function () {
            this.body.show(new Content({
                model: this.model,
                columns: this.options.columns,
                collection: this.options.collection
            }));
        },

        buildFooter: function () {
            this.footer.show(new Footer({
                model: this.model,
                columns: this.options.columns,
                collection: this.options.collection
            }));
        },

        build: function () {
            this.buildHeader();
            this.buildContent();
            this.buildFooter();
        }

    });

});
