define (require) ->
  'use strict'

  Backbone = require('backbone')

  require('backbone-nested')

  class Model extends Backbone.NestedModel

    isYou: (user) ->
      @get('owner.id') is user.id

  new Model
