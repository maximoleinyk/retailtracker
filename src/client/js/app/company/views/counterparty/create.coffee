define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')

  Layout.extend

    template: require('hbs!./create.hbs')
    className: 'page page-2thirds'

    cancel: ->
      @navigateTo('/counterparty')

    create: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.create()
      .then =>
        @navigateTo('/counterparty')
      .catch (err) =>
        @validation.show(err)
