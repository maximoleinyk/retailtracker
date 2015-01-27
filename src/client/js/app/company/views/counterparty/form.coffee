define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')

  Layout.extend

    template: require('hbs!./form.hbs')
    className: 'page page-2thirds'

    cancel: ->
      @navigateTo('/counterparty')

    submit: (e) ->
      e.preventDefault()

      @model.save().then =>
        @navigateTo('/counterparty')
