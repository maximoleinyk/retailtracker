define(function (require) {

    var Marionette = require('marionette'),
        Header = require('./header'),
        Content = require('./content'),
        Footer = require('./footer'),
        EmptyView = require('./emptyView'),
        _ = require('underscore');

    return Marionette.Layout.extend({

        template: require('hbs!./main'),
        tagName: 'table',

        regions: {
            header: 'thead',
            footer: 'tfoot'
        },

        initialize: function () {
            this.wasEmpty = true;
            this.skipInitialAutoFocus = this.options.skipInitialAutoFocus || false;
        },

        onRender: function () {
            this.addListeners();
            this.build();
        },

        addListeners: function () {
            this.listenTo(this.options.collection, 'add remove reset', this.toggleEmptyView, this);
        },

        toggleEmptyView: function () {
            if (this.options.collection.length > 0 && this.wasEmpty) {
                this.destroyContentView();
                this.buildContent();
            } else if (!this.options.collection.length) {
                this.destroyContentView();
                this.buildEmptyView();
            }
        },

        buildEmptyView: function () {
            if (_.isUndefined(this.options.defaultEmptyText)) {
                return;
            }
            this.$el.find('thead').after(Marionette.$('<tbody/>'));
            this.contentView = new EmptyView({
                el: this.$el.find('tbody'),
                columns: this.options.columns,
                title: this.options.defaultEmptyText
            });
            this.contentView.render();
            this.wasEmpty = true;
        },

        buildHeader: function () {
            if (this.options.withoutHeader) {
                return;
            }
            this.header.show(new Header({
                columns: this.options.columns,
                items: this.options.collection,
                numerable: this.options.numerable
            }));
        },

        buildContent: function () {
            this.$el.find('thead').after(Marionette.$('<tbody/>'));
            this.contentView = new Content({
                el: this.$el.find('tbody'),
                columns: this.options.columns,
                collection: this.options.collection,
                numerable: this.options.numerable,
                editable: this.options.editable,
                isActionCellVisible: this.options.isActionCellVisible
            });
            this.contentView.render();
            this.wasEmpty = false;
        },

        buildFooter: function () {
            // do not render footer with editable row if grid is not editable
            if (!_.isObject(this.options.editable)) {
                return;
            }
            this.footer.show(new Footer({
                columns: this.options.columns,
                items: this.options.collection,
                numerable: this.options.numerable,
                editable: this.options.editable,
                skipInitialAutoFocus: this.skipInitialAutoFocus
            }));
        },

        build: function () {
            this.buildHeader();
            this.toggleEmptyView();
            this.buildFooter();
        },

        onClose: function () {
            this.destroyContentView();
        },

        destroyContentView: function () {
            if (this.contentView) {
                this.contentView.close();
            }
            this.contentView = null;
        }

    });

});
