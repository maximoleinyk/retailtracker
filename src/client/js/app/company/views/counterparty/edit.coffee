define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')

  Layout.extend

    template: require('hbs!./edit.hbs')
    className: 'page page-2thirds'

    cancel: ->
      @navigateTo('/counterparty')

    update: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.update()
      .then =>
        @navigateTo('/counterparty')
      .catch (err) =>
        @validation.show(err)
