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

    logout: ->
      http.del '/security/logout', ->
        window.location.reload()