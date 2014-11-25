define (require) ->
  'use strict'

  Backbone = require('backbone')

  class Model extends Backbone.NestedModel
    
    parse: (json) ->
      json.id = json._id
      delete json.__v
      delete json._id

      if json.owner
        json.owner.id = json.owner._id
        delete json.owner.__v
        delete json.owner._id

      json

    isYou: (user) ->
      @get('owner').id is user.id

  new Model
