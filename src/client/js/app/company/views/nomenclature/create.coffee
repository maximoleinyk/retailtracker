define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  _ = require('underscore')

  Layout.extend

    template: require('hbs!./create')
    className: 'container'

    onRender: ->

    templateHelpers: ->

    renderSelect: ->
      @ui.$select.select2()

    cancel: ->
      @navigateTo('')

    create: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.create()
      .then =>
        @navigateTo('')
      .then null, (err) =>
        @validation.show(err)
