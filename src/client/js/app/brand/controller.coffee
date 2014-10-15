define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  HomePage = require('cs!./views/home')
  SettingsPage = require('cs!./views/settings/main')

  Controller.extend

    home: ->
      @openPage new HomePage

    settings: (view) ->
      @openPage new SettingsPage({
        view: view
      })
