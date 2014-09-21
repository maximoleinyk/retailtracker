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

        initialize: function(options) {
            options = options || {};

            this.state = options.state || 'view';
            this.editable = options.editable || false;
            this.numerable = options.numerable || false;
        },

        onRender: function () {
            this.obtainColumns();
            this.build();
        },

        obtainColumns: function() {
            if (this.numerable) {
                this.options.columns.unshift({
                    field: 'numerable',
                    type: 'autoincrement',
                    title: '#'
                })
            }
			if (this.editable) {
				this.options.columns.push({
					field: 'editable',
					type: 'edit',
					title: ''
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
                columns: this.options.columns,
                collection: this.options.collection,
                numerable: this.numerable,
                editable: this.editable,
                state: this.state,
				onCreate: this.options.onCreate,
				onSave: this.options.onSave
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
