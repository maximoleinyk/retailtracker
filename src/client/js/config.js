require.config({

	baseUrl: '/static/js',

	packages: [
		{
			name: 'cs',
			location: 'libs/require-cs',
			main: 'cs'
		},
		{
			name: 'coffee-script',
			location: 'libs/coffee-script/extras',
			main: 'coffee-script'
		},
		{
			name: 'cs-builder',
			location: 'libs/require-cs',
			main: 'cs-builder'
		}
	],

	paths: {
		jquery: 'libs/jquery/dist/jquery',
		underscore: 'libs/underscore/underscore',
		backbone: 'libs/backbone/backbone',
		'backbone-nested': 'libs/backbone-nested-model/backbone-nested',
		'backbone.wreqr': 'libs/backbone.wreqr/lib/amd/backbone.wreqr',
		'backbone.babysitter': 'libs/backbone.babysitter/lib/backbone.babysitter',
		marionette: 'libs/marionette/lib/core/amd/backbone.marionette',
		handlebars: 'libs/handlebars/handlebars',
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
		eventBus: 'app/common/eventBus',
		d3: 'libs/d3/d3',
		typeahead: 'libs/typeahead.js/dist/typeahead.jquery'
	},

	shim: {
		eventBus: {
			deps: ['backbone.wreqr']
		},
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
		hbs: {
			deps: ['handlebars']
		},
		grid: {
			deps: ['handlebars', 'marionette']
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
		'cs!app/common/io': {
			deps: ['socket.io']
		}
	},

	deps: [
		'cs!app/common/main'
	]

});

window.RetailRegister || (window.RetailRegister = {});
