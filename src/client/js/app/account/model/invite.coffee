define (require) ->
  'use strict'

  Backbone = require('backbone')
  http = require('util/http')
  Promise = require('rsvp').Promise

  Backbone.Model.extend

    fetch: (options) ->
      options or= {}

      new Promise (resolve, reject) =>
        success = (data) =>
          @set(data, options)
          @trigger('sync', @, data, options)
        http.get('/security/invite' + @id, success, reject)
