define (require) ->
  'use strict'

  Collection = require('cs!app/common/collection')
  Formula = require('cs!app/company/models/formula')
  request = require('app/common/request')

  class Formulas extends Collection

    model: Formula

    fetch: ->
      request.get('/formula/all').then (result) =>
        @reset(result, {parse: true})
