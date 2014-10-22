define (require) ->
  'use strict'

  http = require('util/http')
  Marionette = require('marionette')
  Promise = require('rsvp').Promise
  RegistrationCompleted = require('cs!./completed')

  Marionette.ItemView.extend

    template: require('hbs!./approve')

    approve: (e) ->
      e.preventDefault()
      @validation.reset()

      register = new Promise (resolve, reject) =>
        http.post '/security/approve', @model.toJSON(), (err, response) ->
          if err then reject(err) else resolve(response)

      register
      .then =>
        @eventBus.trigger('open:page', new RegistrationCompleted)
      .then null, (err) =>
        @validation.show(err.errors)
