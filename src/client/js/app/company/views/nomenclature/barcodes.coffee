define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  Grid = require('util/grid/main')
  Collection = require('cs!app/common/mongoCollection')
  barcodeTypes = require('util/barcodeTypes')

  Layout.extend

    template: require('hbs!./barcodes')

    initialize: ->
      @collection = new Collection(@model.get('barcodes'), {parse: true})

    onRender: ->
      @wrapper.show new Grid({
        collection: @collection
        withoutHeader: true
        columns: [
          {
            field: 'value'
            placeholder: window.RetailTracker.i18n.selectBarcode
            type: 'select'
            data: barcodeTypes
            formatter: (value) =>
              value
            formatResult: (modelJSON) =>
              modelJSON.text
            width: 175
          },
          {
            field: 'type'
            type: 'string'
          }
        ]
        editable: @
        skipInitialAutoFocus: true
      })

    update: ->
      @model.set('barcodes', @collection.toJSON())

    onCreate: (barcode, callback) ->
      return callback({ value: window.RetailTracker.i18n.enterValue }) if not barcode.get('value')
      barcode.commit()
      @collection.add(barcode)
      @update()
      callback()

    onSave: (barcode, callback) ->
      return callback({ value: window.RetailTracker.i18n.enterValue }) if not barcode.get('value')
      barcode.commit()
      @update()
      callback()

    onCancel: (barcode, callback) ->
      barcode.reset()
      callback()

    onDelete: (barcode, callback) ->
      @collection.remove(barcode)
      @update()
      callback()