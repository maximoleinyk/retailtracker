define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class Nomenclature extends Model

    urlRoot: '/nomenclature'

    defaults: ->
      attributes: []
      barcodes: []
