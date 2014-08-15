define (require) ->
  'use strict'

  http = require('util/http')
  Marionette = require('marionette')
  SuccessRegistration = require('cs!app/account/view/success')

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

      originButtonLabel = @ui.registerButton.val()

      @validation.reset()
      @ui.registerButton.text('Регистрация...').attr('disabled', true)

      register = new Promise (resolve, reject) =>
        http.post '/security/register', @model.toJSON(), resolve, reject

      register
      .then =>
        @eventBus.trigger('page:open', new RegistrationSuccess())
      .then null, (err) =>
        @validation.show(err.errors)
        @ui.registerButton.text(originButtonLabel).removeAttr('disabled')

