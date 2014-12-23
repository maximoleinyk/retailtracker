define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  numeral = require('numeral')

  Layout.extend

    template: require('hbs!./home.hbs')

    onCreate: (model, callback) ->
      return callback(model.validationError) if not model.isValid()
      @collection.add(model)
      callback()

    onSave: (model, callback) ->
      return callback(model.validationError) if not model.isValid()
      callback()

    onDelete: (model, callback) ->
      @collection.remove(model)
      callback()

    onShow: ->
      @container.show(new Grid({
        collection: @collection
        numerable: true
        editable: @
        columns: [
          {
            field: 'product'
            title: 'Позиция'
            type: 'select'
            url: '/products/search'
            placeholder: 'Выберите продукт'
            formatter: (value, model) ->
              model.get('productName')
            formatResult: (json) ->
              json?.productName
            onSelection: (object, model) ->
              model.set({
                price: object.price
                productName: object.productName
                count: 1
              })
          }
          {
            field: 'count'
            title: 'Кол-во'
            type: 'number'
            formatter: (value) ->
              numeral(value).format('0')
            width: 100
          }
          {
            field: 'price'
            title: 'Цена'
            type: 'number'
            width: 180
            attributes:
              readonly: true
            formatter: (value) ->
              numeral(value).format('0,0.00')
          }
        ]
      }))
