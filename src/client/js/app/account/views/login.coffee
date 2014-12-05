define (require) ->
  'use strict'

  Security = require('cs!app/account/models/security')
  Marionette = require('marionette')
  context = require('cs!app/common/context')

  Marionette.ItemView.extend

    template: require('hbs!./login.hbs')

    initialize: ->
      @model = new Security()

    login: (e) ->
      e.preventDefault();
      @validation.reset()

      this.model.login()
      .then =>
        window.location.replace('/page/' + context.get('redirectUrl'))
      .then null, (err) =>
          @validation.show(err.errors)

      @model.unset('password')
