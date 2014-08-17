define (require) ->
  'use strict'

  http = require('util/http')
  Marionette = require('marionette')

  Marionette.ItemView.extend

    template: require('hbs!./register')
    binding: true

    ui:
      registerButton: '[data-id="register"]'

    events:
      'click @ui.registerButton': 'register'

    initialize: ->
      @model = new Backbone.Model()

    register: (e) ->
      e.preventDefault()

      originButtonLabel = @ui.registerButton.text()

      @validation.reset()
      @ui.registerButton.text('Регистрация...').attr('disabled', true)

      register = new Promise (resolve, reject) =>
        http.post '/security/register', @model.toJSON(), (err, response) ->
          if err then reject(err) else resolve(response)

      register
      .then =>
        @eventBus.trigger('router:navigate:silent', 'register/success')
      .then null, (err) =>
        @validation.show(err.errors)
        @ui.registerButton.text(originButtonLabel).removeAttr('disabled')

