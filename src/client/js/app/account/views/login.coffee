define (require) ->
  'use strict'

  Security = require('cs!app/account/models/security')
  Marionette = require('marionette')
  sessionStore = require('util/sessionStore')

  Marionette.ItemView.extend

    template: require('hbs!./login')

    initialize: ->
      @model = new Security()

    login: (e) ->
      e.preventDefault();
      @validation.reset()

      this.model.login()
      .then =>
        url = sessionStore.get('redirectUrl')
        window.location.replace('/page/' + url)
      .then null, (err) =>
          @validation.show(err.errors)

      @model.unset('password')
