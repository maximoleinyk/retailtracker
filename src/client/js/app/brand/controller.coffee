define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  HomePage = require('cs!./views/home')
  SettingsPage = require('cs!./views/settings/main')
  Uom = require('cs!./collections/uoms')
  UomPage = require('cs!./views/uom/main')

  Controller.extend

    home: ->
      @openPage new HomePage

    uom: ->
      collection = new Uom
      collection.fetch()
      .then =>
        @openPage new UomPage({
          collection: collection
        })

    settings: (view) ->
      @openPage new SettingsPage({
        view: view
      })
