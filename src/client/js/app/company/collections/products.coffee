define (require) ->
  'use strict'

  Backbone = require('backbone')
  ProductItem = require('cs!app/company/models/productItem')
  Promise = require('rsvp').Promise
  http = require('util/http')

  Backbone.Collection.extend

    model: ProductItem

    fetch: ->
      load = new Promise (resolve, reject) ->
        http.get '/product/items', (err, response) =>
          if err then reject(err) else resolve(response)

      load.then (result) =>
        @reset(result)