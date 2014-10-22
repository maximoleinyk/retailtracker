define (require) ->
  'use strict'

  Marionette = require('marionette')
  http = require('util/http')
  Promise = require('rsvp').Promise

  Marionette.ItemView.extend

    template: require('hbs!./security')
    className: 'blank'

    save: (e) ->
      e.preventDefault()
      @validation.reset()

      changeSecuritySettings = new Promise (resolve, reject) =>
        http.post '/settings/change/security', @model.toJSON(), (err, response) ->
          if err then reject(err) else resolve(response)

      changeSecuritySettings
      .then =>
        @model.unset('oldPassword')
        @model.unset('password')
        @model.unset('confirmPassword')
      .then null, (err) =>
        @validation.show(err.errors)

