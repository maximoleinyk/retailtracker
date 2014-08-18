define (require) ->
  'use strict'

  http = require('util/http')
  Marionette = require('marionette')
  Promise = require('rsvp').Promise

  Marionette.ItemView.extend
    template: require('hbs!./changePassword')
    binding: true

    events:
      'submit': 'change'

    change: (e) ->
      e.preventDefault()
      @validation.reset()

      register = new Promise (resolve, reject) =>
        http.post '/security/password/change', @model.toJSON(), (err, response) ->
          if err then reject(err) else resolve(response)

      register
      .then =>
        @eventBus.trigger('router:navigate:silent', 'forgotPasswordChanged')
      .then null, (err) =>
        @validation.show(err.errors)
