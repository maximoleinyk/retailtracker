define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class Store extends Model

    urlRoot: '/store'
