define (require) ->
  'use strict'

  Promise = require('rsvp').Promise
  http = require('util/http')
  Backbone = require('backbone')
  Marionette = require('marionette')
  sessionStore = require('util/sessionStore')

  Marionette.ItemView.extend

    template: require('hbs!./login')
    binding: true

    initialize: ->
      @model = new Backbone.Model()

    login: (e) ->
      e.preventDefault();
      @validation.reset()

      authenticate = new Promise (resolve, reject) =>
        http.post '/security/login', @model.toJSON(), (err, response) ->
          if err then reject(err) else resolve(response)

      authenticate
      .then =>
        url = sessionStore.get('redirectUrl')
        window.location.replace('/page/' + url)
      .then null, (err) =>
          @validation.show(err.errors)

      @model.unset('password')
