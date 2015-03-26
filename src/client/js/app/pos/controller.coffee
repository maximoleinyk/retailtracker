define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  Dashboard = require('cs!./views/dashboard')

  Controller.extend

    dashboard: ->
      @openPage new Dashboard
