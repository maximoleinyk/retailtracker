require.config({

    baseUrl: '/static/js',

    paths: {
        jquery: 'libs/jquery/dist/jquery',
        underscore: 'libs/underscore/underscore',
        backbone: 'libs/backbone/backbone',
        'backbone.wreqr': 'libs/backbone.wreqr/lib/amd/backbone.wreqr',
        'backbone.babysitter': 'libs/backbone.babysitter/lib/backbone.babysitter',
        marionette: 'libs/marionette/lib/core/amd/backbone.marionette',
        handlebars: 'libs/handlebars/handlebars',
        'handlebars-compiler': 'libs/handlebars/handlebars.runtime',
        rivets: 'libs/rivets/dist/rivets',
        cs: 'libs/require-cs/cs',
        'coffee-script': 'libs/coffee-script/extras/coffee-script',
        text: 'libs/requirejs-text/text',
        bootstrap: 'libs/bootstrap/dist/js/bootstrap',
        'socket.io': 'libs/socket.io-client/socket.io',
        rsvp: 'libs/rsvp/rsvp.amd',
        select2: 'libs/select2/select2',
        respond: 'libs/respond/dest/respond.src',
        moment: 'libs/moment/moment'
    },

    packages: [
        {
            name: 'hbs',
            location: 'libs/requirejs-hbs',
            main: 'hbs'
        }
    ],

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
            deps: ['text', 'handlebars']
        },
        bootstrap: {
            deps: ['jquery']
        },
		grid: {
			deps: ['marionette']
		}
    },

    deps: [
        'respond',
        'bootstrap',
		'util/eventBus',
		'util/interceptors',
		'util/http',
		'util/io'
    ]

});

window.RetailTracker || (window.RetailTracker = {});
