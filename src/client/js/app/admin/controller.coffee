define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  HomePage = require('cs!./views/home')
  SettingsPage = require('cs!./views/settings/main')
  WarehouseItems = require('cs!app/admin/collections/warehouseItems')
  http = require('util/http')

  Controller.extend

    home: ->
      collection = new WarehouseItems

      http.get '/warehouse/items', (err, response) =>
        collection.reset(response)
        @openPage(new HomePage({
          collection: collection
        }))

    settings: (view) ->
      @openPage new SettingsPage({ view: view })
