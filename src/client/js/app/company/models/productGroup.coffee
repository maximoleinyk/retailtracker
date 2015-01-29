define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class ProductGroup extends Model

    urlRoot: '/productgroup'
