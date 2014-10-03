define (require) ->
  'use strict'

  Marionette = require('marionette')
  http = require('util/http')
  Promise = require('rsvp').Promise

  Marionette.ItemView.extend
    template: require('hbs!./profile')
    className: 'blank'
    binding: true

    save: (e) ->
      e.preventDefault()
      @validation.reset()

      changeProfileSettings = new Promise (resolve, reject) =>
        http.post '/settings/change/profile', @model.toJSON(), (err, response) ->
          if err then reject(err) else resolve(response)

      changeProfileSettings
      .then =>
        console.log('Success')
      .then null, (err) =>
        @validation.show(err.errors)
