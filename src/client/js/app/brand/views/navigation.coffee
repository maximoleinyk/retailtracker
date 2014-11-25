define (require) ->
  'use strict'

  Marionette = require('marionette')
  http = require('util/http')
  context = require('cs!app/common/context')

  Marionette.ItemView.extend

    template: require('hbs!./navigation')
    tagName: 'header'

    initialize: ->
      @model = context
      @listenTo(context, 'change:owner.firstName', @updateNameLabel, @)
      @listenTo(context, 'change:owner.lastName', @updateNameLabel, @)

    onRender: ->
      @updateNameLabel()

    updateNameLabel: ->
      @ui.$userName.text(@model.get('owner.firstName') + ' ' + @model.get('owner.lastName'))

    logout: ->
      http.del '/security/logout', ->
        window.location.reload()