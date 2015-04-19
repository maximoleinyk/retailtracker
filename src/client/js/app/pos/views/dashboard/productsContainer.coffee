define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')

  ItemView.extend

    template: require('hbs!./productsContainer.hbs')

    templateHelpers: ->
      warehouseItems: @options.warehouseItems.toJSON()
