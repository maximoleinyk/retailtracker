define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  ProductsContainer = require('cs!./productsContainer')
  ItemsList = require('cs!./itemsList')

  Layout.extend

    template: require('hbs!./main.hbs')
    className: 'page page-2thirds'

    onRender: ->
      @renderProducts()
      @renderShoppingList()

    renderProducts: ->
      @products.show new ProductsContainer
        warehouseItems: @options.warehouseItems

    renderShoppingList: ->
      @list.show new ItemsList
