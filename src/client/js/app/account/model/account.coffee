define (require) ->
  'use strict'

  Backbone = require('backbone')
  http = require('util/http')
  Promise = require('rsvp').Promise

  Backbone.Model.extend

    loadInvite: (options) ->
      options or= {}

      getInfo = new Promise (resolve, reject) ->
        http.get '/security/invite/' + options.id, (err, data) ->
          if err then reject(err) else resolve(data)

      getInfo
      .then (data) =>
        @set(data, options)
        @trigger('sync', @, data, options)

    loadLink: (options) ->
      options or= {}

      getInfo = new Promise (resolve, reject) ->
        http.get '/security/forgot/' + options.id, (err, data) ->
          if err then reject(err) else resolve(data)

      getInfo
      .then (data) =>
        @set(data, options)
        @trigger('sync', @, data, options)



