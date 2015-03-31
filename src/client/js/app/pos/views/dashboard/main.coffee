define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  ProductsArea = require('cs!./productArea')
  ShoppingList = require('cs!./shoppingList')

  Layout.extend

    template: require('hbs!./main.hbs')

    onRender: ->
      @renderProducts()
      @renderShoppingList()

    renderProducts: ->
      @products.show new ProductsArea

    renderShoppingList: ->
      @shoppingList.show new ShoppingList
