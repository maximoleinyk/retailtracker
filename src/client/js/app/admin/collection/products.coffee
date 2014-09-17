define (require) ->
  'use strict'

  Backbone = require('backbone')
  Product = require('cs!app/admin/model/product')

  Backbone.Collection.extend({
    model: Product
    url: '/products/search'
  })
