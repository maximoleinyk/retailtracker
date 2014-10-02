define (require) ->
  'use strict'

  http = require('util/http')
  Controller = require('cs!app/common/controller');
  HomePage = require('cs!./views/home')
  SettingsPage = require('cs!./views/settings/main')
  WarehouseItems = require('cs!app/admin/collections/warehouseItems')
  Uom = require('cs!app/admin/collections/uom')
  UomPage = require('cs!app/admin/views/uom/main')

  Controller.extend

    home: ->
      collection = new WarehouseItems

      http.get '/warehouse/items', (err, response) =>
        collection.reset(response)
        @openPage(new HomePage({
          collection: collection
        }))

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
