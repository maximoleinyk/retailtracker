define (require) ->
  'use strict'

  Backbone = require('backbone')
  Uom = require('cs!app/admin/models/uom')
  http = require('util/http')

  Backbone.Collection.extend

    model: Uom

    fetch: ->
      load = new Promise (resolve, reject) ->
        http.get '/uom/all', (err, result) ->
          if err then reject(err) else resolve(result)

      load.then (result) =>
        @set(result)