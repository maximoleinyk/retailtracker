define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  HomePage = require('cs!./views/home')
  ProductItems = require('cs!app/company/collections/productItems')

  Controller.extend

    home: ->
      collection = new ProductItems
      collection.fetch().then =>
        @openPage new HomePage({
          collection: collection
        })