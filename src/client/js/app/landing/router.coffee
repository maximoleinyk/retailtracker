define [
  'backbone'
  'cs!app/common/baseRouter'
  'cs!app/landing/controller'
  'cs!app/common/app'
], (Backbone, BaseRouter, Controller, App) ->
  'use strict'

  Router = BaseRouter.extend
    appRoutes:
      '': 'index'

  App.addInitializer (options) ->
    new Router
      controller: new Controller options

    Backbone.history.start
      pushState: true
      root: '/ui/'
