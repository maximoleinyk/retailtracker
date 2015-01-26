require.config({

	baseUrl: '/static/js',

	paths: {
		jquery: 'libs/jquery/dist/jquery',
		underscore: 'libs/underscore/underscore',
		backbone: 'libs/backbone/backbone',
		'backbone-nested': 'libs/backbone-nested-model/backbone-nested',
		'backbone.wreqr': 'libs/backbone.wreqr/lib/amd/backbone.wreqr',
		'backbone.babysitter': 'libs/backbone.babysitter/lib/backbone.babysitter',
		marionette: 'libs/marionette/lib/core/amd/backbone.marionette',
		handlebars: 'libs/handlebars/handlebars',
		cs: 'libs/require-cs/cs',
		'coffee-script': 'libs/coffee-script/extras/coffee-script',
		bootstrap: 'libs/bootstrap/dist/js/bootstrap',
		'socket.io': 'libs/socket.io-client/socket.io',
		rsvp: 'libs/rsvp/rsvp',
		select2: 'libs/select2/select2',
		select2locale: 'libs/select2/select2_locale_ru',
		select: 'app/common/select',
		moment: 'libs/moment/moment',
		momentRussianLocale: 'libs/moment/locale/ru',
		numeral: 'libs/numeral/numeral',
		cookies: 'libs/cookies-js/src/cookies',
		hbs: 'app/common/plugins/hbs',
		md5: 'libs/md5/js/md5',
		d3: 'libs/d3/d3',
		typeahead: 'libs/typeahead.js/dist/typeahead.jquery'
	},

	shim: {
		jquery: {
			exports: '$'
		},
		underscore: {
			exports: '_'
		},
		backbone: {
			deps: ['underscore', 'jquery'],
			exports: 'Backbone'
		},
		'backbone-nested': {
			deps: ['backbone']
		},
		'backbone.wreqr': {
			deps: ['backbone']
		},
		'backbone.babysitter': {
			deps: ['backbone']
		},
		marionette: {
			deps: ['backbone', 'backbone.wreqr', 'backbone.babysitter']
		},
		handlebars: {
			exports: 'Handlebars'
		},
		cs: {
			deps: ['coffee-script']
		},
		hbs: {
			deps: ['handlebars']
		},
		grid: {
			deps: ['marionette']
		},
		bootstrap: {
			deps: ['jquery']
		},
		'typeahead': {
			deps: ['jquery', 'libs/typeahead.js/dist/bloodhound']
		},
		'libs/typeahead.js/dist/bloodhound': {
			deps: ['jquery']
		},
		select2: {
			deps: ['jquery']
		},
		select2locale: {
			deps: ['select2']
		},
		'cs!app/common/io': {
			deps: ['socket.io']
		}
	},

	deps: [
		'app/common/helpers',
		'bootstrap',
		'typeahead',
		'cs!app/common/io'
	]

});

window.RetailRegister || (window.RetailRegister = {});
