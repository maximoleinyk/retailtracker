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
        'socket.io': 'libs/socket.io-client/socket.io'
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
            deps: ['backbone']
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
        }
    },

    deps: [
        'bootstrap',
        'etc/eventBus',
        'etc/rivets-config',
        'etc/io'
    ]

});

window.RetailTracker || (window.RetailTracker = {});
