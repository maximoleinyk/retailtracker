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
				items: this.options.collection,
                numerable: this.options.numerable
            }))
        },

        buildContent: function () {
            var view = new Content({
                el: this.ui.$content,
                columns: this.options.columns,
                collection: this.options.collection,
                numerable: this.options.numerable,
                editable: this.options.editable,
                state: this.options.state
            });
            view.render();
        },

        buildFooter: function () {
            // do not render footer with editable row if grid is not editable
            if (!this.options.editable) {
                return;
            }
            this.footer.show(new Footer({
                columns: this.options.columns,
                items: this.options.collection,
                numerable: this.options.numerable,
				onCreate: this.options.onCreate
            }));
        },

        build: function () {
            this.buildHeader();
            this.buildContent();
            this.buildFooter();
        }

    });

});
