(function (callback) {

    if (typeof module === 'object') {
        var _ = require('underscore'),
            Backbone = require('backbone'),
            Marionette = require('marionette');
        module.exports = callback(_, Backbone, Marionette);
    } else if (typeof define === 'function' && define.amd) {
        define(['underscore', 'backbone', 'marionette'], callback);
    }

}(function (_, Backbone, Marionette) {

    var $ = Marionette.$;

    return Marionette.Layout.extend({

        initialize: function () {
            this.columns = this.options.columns;
            this.collections = this.options.collection;

            this.registerEventHandlers();
            this.render();
        },

        registerEventHandlers: function () {
            this.listenTo(this.collection, "reset", this.render);
            this.fragment = document.createDocumentFragment();
        },

        render: function () {
            var table = $('<table/>');

            table.append(this.buildHeader());
            table.append(this.buildContent());

            this.fragment.appendChild(table.get(0));
            this.$el.html(this.fragment);
        },

        buildContent: function () {
            var tbody = $('<tbody/>'),
                self = this;

            this.collection.each(function (model) {
                var tr = $('<tr/>');

                _.each(self.columns, function (value, property) {
                    var td = $('<td/>'),
                        text = model.get(property);

                    if (typeof value.format === 'function') {
                        text = value.format(text);
                    }

                    td.text(text);
                    tr.append(td);
                });

                tbody.append(tr);
            });

            return tbody;
        },

        buildHeader: function () {
            var thead = $('<thead/>'),
                tr = $('<tr/>');

            _.each(this.columns, function (value) {
                var th = $('<th/>'),
                    text = typeof value.title === 'function' ? value.title() : value.title;
                th.text(text);
                tr.append(th);
            });

            thead.append(tr);

            return thead;
        }
    });

}));
