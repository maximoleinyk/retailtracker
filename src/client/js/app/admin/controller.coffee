define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  HomePage = require('cs!./view/home')
  SettingsPage = require('cs!./view/settings/main')

  Controller.extend

    home: ->
      @openPage(new HomePage)

    settings: (view) ->
      @openPage new SettingsPage({ view: view })
