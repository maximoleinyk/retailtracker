define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  Dashboard = require('cs!./views/dashboard/main')
  WarehouseItems = require('cs!app/company/collections/warehouseItems')

  Controller.extend

    dashboard: ->
      warehouseItems = new WarehouseItems
      warehouseItems.fetch().then =>
        @openPage new Dashboard
          warehouseItems: warehouseItems
