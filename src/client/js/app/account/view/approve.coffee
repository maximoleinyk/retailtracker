define (require) ->
  'use strict'

  http = require('util/http')
  Marionette = require('marionette')
  Promise = require('rsvp').Promise

  Marionette.ItemView.extend
    template: require('hbs!./approve')
    binding: true

    events:
      'submit': 'approve'

    approve: (e) ->
      e.preventDefault()
      @validation.reset()

      register = new Promise (resolve, reject) =>
        http.post '/security/approve', @model.toJSON(), (err, response) ->
          if err then reject(err) else resolve(response)

      register
      .then =>
        @eventBus.trigger('router:navigate:silent', 'registrationCompleted')
      .then null, (err) =>
        @validation.show(err.errors)
