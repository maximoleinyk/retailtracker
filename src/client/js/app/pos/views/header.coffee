define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  http = require('app/common/http')
  context = require('cs!app/common/context')
  avatar = require('cs!app/common/avatar')

  ItemView.extend

    template: require('hbs!./header.hbs')

    initialize: ->
      @model = context
