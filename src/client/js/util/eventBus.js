define(function (require) {
	'use strict';

	var Backbone = require('backbone'),
		Marionette = require('marionette');

	var bus = new Backbone.Wreqr.EventAggregator();

	Backbone.View.prototype.eventBus = Backbone.Collection.prototype.eventBus = Backbone.Model.prototype.eventBus = bus;
	Marionette.AppRouter.prototype.eventBus = Marionette.Controller.prototype.eventBus = bus;

	var delegateEvents = Marionette.View.prototype.delegateEvents,
		undelegateEvents = Marionette.View.prototype.undelegateEvents;

	Marionette.View.prototype.delegateEvents = function () {
		delegateEvents.apply(this, arguments);
		Marionette.bindEntityEvents(this, this.eventBus, Marionette.getOption(this, 'appEvents'));
	};

	Marionette.View.prototype.undelegateEvents = function () {
		undelegateEvents.apply(this, arguments);
		Marionette.unbindEntityEvents(this, this.eventBus, Marionette.getOption(this, 'appEvents'));
	};

	Marionette.bus = Backbone.bus = bus;

	return bus;

});
