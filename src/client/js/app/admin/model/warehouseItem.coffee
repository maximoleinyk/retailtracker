define (require) ->
  'use strict'

  Backbone = require('backbone')
  _ = require('underscore')

  Backbone.Model.extend({
    validate: ->
      result = {}

      if not @get('product')
        result['product'] = 'Select product'

      if not @get('count')
        result['count'] = 'Choose count'

      if _.isEmpty(result) then undefined else result
  })