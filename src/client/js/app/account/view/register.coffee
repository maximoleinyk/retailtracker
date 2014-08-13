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

    register: (e) ->
      e.preventDefault()

      register = new Promise (resolve, reject) ->
        http.post '/security/register', @model.toJSON(), resolve, reject

      register.then ->
        console.log('Зарегистрирован!')

      .then null, (err) ->
        console.log(err)