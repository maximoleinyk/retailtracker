define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  Promise = require('rsvp').Promise

  class Nomenclature extends Model

    urlRoot: '/nomenclature'

    defaults: ->
      attributes: []
      barcodes: []
