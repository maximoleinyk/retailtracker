define (require) ->
  'use strict'

  Marionette = require('marionette')

  Marionette.ItemView.extend

    template: require('hbs!./profile')
    binding: true

    save: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.changeProfileSettings()
      .then =>
        @navigate('')
      .then null, (err) =>
        @validation.show(err.errors)
