define (require) ->
  'use strict'

  Backbone = require('backbone')

  require('backbone-nested')

  class Model extends Backbone.NestedModel

    initialize: ->
      @on 'change', =>
        console.log(@changed)

    isYou: (user) ->
      @get('owner.id') is user.id

  new Model
