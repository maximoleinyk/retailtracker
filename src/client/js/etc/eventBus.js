define(['marionette', 'backbone', 'underscore'], function (Marionette, Backbone, _) {
    'use strict';

    var vent = new Backbone.Wreqr.EventAggregator(),
        bind = function (init) {
            return function () {
                this.appEvents = this.appEvents || {};
                this.eventBus = vent;

                _.each(this.appEvents, function (handler, event) {
                    this.listenTo(this.eventBus, event, this[handler]);
                }, this);

                init.apply(this, arguments);
            };
        };

    Backbone.View.prototype.constructor = bind(Backbone.View.prototype.constructor);
    Backbone.Router.prototype.constructor = bind(Backbone.Router.prototype.constructor);
    Marionette.Controller.prototype.constructor = bind(Marionette.Controller.prototype.constructor);

});
