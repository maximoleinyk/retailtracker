define (require) ->
  'use strict'

  Backbone = require('backbone')
  Uom = require('cs!app/brand/models/uom')
  http = require('util/http')
  Promise = require('rsvp').Promise

  Backbone.Collection.extend

    model: Uom

    fetch: ->
      load = new Promise (resolve, reject) ->
        http.get '/uom/all', (err, result) ->
          if err then reject(err) else resolve(result)

      load.then (result) =>
        @reset(result)