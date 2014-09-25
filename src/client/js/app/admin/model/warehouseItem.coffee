define (require) ->
  'use strict'

  Backbone = require('backbone')
  _ = require('underscore')

  Backbone.Model.extend({
    validate: ->
      result = {}

      if not @get('product')
        result['product'] = 'Необходимо указать позицию'

      if not +@get('count')
        result['count'] = 'Укажите количество'

      if _.isEmpty(result) then undefined else result
  })