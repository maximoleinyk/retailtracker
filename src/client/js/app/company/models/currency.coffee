define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class Currency extends Model

    defaults:
      rate: 1
      code: 'USD'

    getTemplates: ->
      @promise('get', '/currency/templates/get')
