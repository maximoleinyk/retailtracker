define (require) ->
  'use strict'

  Marionette = require('marionette')

  Marionette.ItemView.extend

    template: require('hbs!./security')

    save: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.changeSecuritySettings()
      .then =>
        @model.unset('oldPassword')
        @model.unset('password')
        @model.unset('confirmPassword')
        @navigate('')
      .then null, (err) =>
        @validation.show(err.errors)

