define (require) ->
  'use strict'

  Backbone = require('backbone')
  BaseRouter = require('cs!app/common/baseRouter')
  Controller = require('cs!app/landing/controller')
  App = require('cs!app/common/app')

  Router = BaseRouter.extend
    appRoutes:
      '': 'index'

  App.addInitializer (options) ->
    new Router
      controller: new Controller options

    Backbone.history.start
      pushState: true
      root: '/ui/'
