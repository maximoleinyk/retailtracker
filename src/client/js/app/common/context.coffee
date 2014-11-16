define (require) ->
  'use strict'

  Backbone = require('backbone')

  class Model extends Backbone.Model
    
    idAttribute: '_id'

  new Model
