(function (callback) {

    if (typeof module === 'object') {
        var _ = require('underscore'),
            Backbone = require('backbone'),
            Marionette = require('marionette'),
            template = require('hbs!./main');
        module.exports = callback(_, Backbone, Marionette, template);
    } else if (typeof define === 'function' && define.amd) {
        define(['underscore', 'backbone', 'marionette', 'hbs!util/grid/main'], callback);
    }

}(function (_, Backbone, Marionette, template) {

    var $ = Marionette.$;

    var Footer = Marionette.ItemView.extend({
    });

    var Header = Marionette.ItemView.extend({

//        build: function() {
//            var thead = $('<thead/>'),
//                tr = $('<tr/>');
//
//            _.each(this.columns, function (value) {
//                var th = $('<th/>'),
//                    text = typeof value.title === 'function' ? value.title() : value.title;
//                th.text(text);
//                tr.append(th);
//            });
//
//            thead.append(tr);
//
//            return thead;
//        }

    });

    var Row = Marionette.Layout.extend({

//        render: function() {
//            var tr = $('<tr/>');
//
//            _.each(this.options.columns, function (value, property) {
//                var td = $('<td/>'),
//                    text = model.get(property);
//
//                if (typeof value.format === 'function') {
//                    text = value.format(text);
//                }
//
//                td.text(text);
//                tr.append(td);
//            });
//
//            return tr;
//        }

    });

    var Content = Marionette.CollectionView.extend({

//        build: function() {
//            var tbody = $('<tbody/>'),
//                self = this;
//
//            this.collection.each(function (model) {
//                var view = self.addRow(model, tbody);
//                view.render();
//                tbody.append(view.$el);
//            });
//
//            return tbody;
//
//            var tr = $('<tr/>');
//
//            _.each(self.columns, function (value, property) {
//                var td = $('<td/>'),
//                    text = model.get(property);
//
//                if (typeof value.format === 'function') {
//                    text = value.format(text);
//                }
//
//                td.text(text);
//                tr.append(td);
//            });
//
//            tbody.append(tr);
//        },

        template: '<div class="content"></div>',
        itemView: Row,

        buildItemView: function(model, ItemView) {
            return new ItemView({
                el: this.table,
                columns: this.columns,
                model: model
            });
        }

    });

    return Marionette.Layout.extend({

        template: template,

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

        buildFooter: function() {
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

}));
