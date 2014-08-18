define (require) ->
  'use strict'

  http = require('util/http')
  Marionette = require('marionette')
  sessionStore = require('util/sessionStore')
  Promise = require('rsvp').Promise

  Marionette.ItemView.extend
    template: require('hbs!./forgot')
    binding: true

    initialize: ->
      @model = new Backbone.Model()

    events:
      'submit': 'sendEmail'

    sendEmail: (e) ->
      e.preventDefault();
      @validation.reset()

      generateLink = new Promise (resolve, reject) =>
        http.post '/security/forgot', @model.toJSON(), (err, response) ->
          if err then reject(err) else resolve(response)

      generateLink
      .then =>
        @eventBus.trigger('router:navigate:silent', 'forgotPasswordLinkSent')
      .then null, (err) =>
        @validation.show(err.errors)