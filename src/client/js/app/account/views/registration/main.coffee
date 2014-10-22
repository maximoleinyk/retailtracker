define (require) ->
  'use strict'

  http = require('util/http')
  Marionette = require('marionette')
  Promise = require('rsvp').Promise
  RegistrationSuccessPage = require('cs!./sent')
  Backbone = require('backbone')

  Marionette.ItemView.extend

    template: require('hbs!./main')

    initialize: ->
      @model = new Backbone.Model()

    register: (e) ->
      e.preventDefault()

      originButtonLabel = @ui.$registerButton.text()

      @validation.reset()
      @ui.$registerButton.text('Регистрация...').attr('disabled', true)

      register = new Promise (resolve, reject) =>
        http.post '/security/register', @model.toJSON(), (err, response) ->
          if err then reject(err) else resolve(response)

      register
      .then =>
        @eventBus.trigger('open:page', new RegistrationSuccessPage)
      .then null, (err) =>
        @validation.show(err.errors)
        @ui.$registerButton.text(originButtonLabel).removeAttr('disabled')

