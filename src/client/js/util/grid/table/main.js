define(function (require) {

    var Marionette = require('marionette'),
        Header = require('./header'),
        Content = require('./content'),
        Footer = require('./footer');

    return Marionette.Layout.extend({

        template: require('hbs!./main'),
        tagName: 'table',

        ui: {
            $content: 'tbody'
        },

        regions: {
            header: 'thead',
            footer: 'tfoot'
        },

        onRender: function () {
            this.build();
        },

        buildHeader: function () {
            this.header.show(new Header({
                columns: this.options.columns,
                numerable: this.options.numerable
            }))
        },

        buildContent: function () {
            var view = new Content({
                el: this.ui.$content,
                columns: this.options.columns,
                collection: this.options.collection,
                numerable: this.options.numerable
            });
            view.render();
        },

        buildFooter: function () {
            this.footer.show(new Footer({
                columns: this.options.columns,
                items: this.options.collection,
                numerable: this.options.numerable
            }));
        },

        build: function () {
            this.buildHeader();
            this.buildContent();
            this.buildFooter();
        }

    });

});
