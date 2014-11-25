define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  _ = require('underscore')

  Layout.extend

    template: require('hbs!./edit')
    className: 'container'

    cancel: ->
      @navigateTo('')

    update: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.update()
      .then =>
        @navigateTo('')
      .then null, (err) =>
        @validation.show(err)
