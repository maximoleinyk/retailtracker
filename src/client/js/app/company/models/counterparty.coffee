define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class Counterparty extends Model

    urlRoot: '/counterparty'
