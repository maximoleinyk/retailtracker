define (require) ->
  'use strict'

  Marionette = require('marionette')
  Backbone = require('backbone')
  template = require('hbs!./dashboard')

  Marionette.ItemView.extend
    template: template
    binding: true

    initialize: ->
      @model = new Backbone.Model()

    ui:
      $submitButton: '[data-id="login"]'

    events:
      'click @ui.$submitButton': 'login'

    login: (e) ->
      e.preventDefault()

      $.ajax({
        method: 'POST'
        url: '/security/login'
        contentType: 'application/json'
        data: JSON.stringify({
          username: 'login'
          password: 'password'
        })
      })
