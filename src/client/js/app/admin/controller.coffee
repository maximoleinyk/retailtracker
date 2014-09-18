define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  HomePage = require('cs!./view/home')
  SettingsPage = require('cs!./view/settings/main')
  WarehouseItems = require('cs!app/admin/collection/warehouseItems')
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
