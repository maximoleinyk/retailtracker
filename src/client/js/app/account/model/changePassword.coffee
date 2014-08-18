define (require) ->
  'use strict'

  Backbone = require('backbone')
  http = require('util/http')
  Promise = require('rsvp').Promise

  Backbone.Model.extend

    fetch: (options) ->
      options or= {}

      loadInvite = new Promise (resolve, reject) =>
        http.get '/security/forgot/' + @id, (err, data) ->
          if err then reject(err) else resolve(data)

      loadInvite
      .then (data) =>
        @set(data, options)
        @trigger('sync', @, data, options)

