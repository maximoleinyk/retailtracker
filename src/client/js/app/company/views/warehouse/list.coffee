define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  Grid = require('util/grid/main')

  Layout.extend

    template: require('hbs!./list.hbs')
    className: 'container'

    initialize: (options) ->
      @collection = options.collection

    onCreate: (model, callback) ->
      model.create (err, model) =>
        return callback(err) if err
        @collection.add(model)
        callback(null)

    onSave: (model, callback) ->
      model.update (err) ->
        if err then callback(err) else callback(null)

    onDelete: (model, callback) ->
      model.delete (err) =>
        return callback(err) if err
        @collection.remove(model)
        callback(err)

    onCancel: (model, callback) ->
      model.reset()
      callback()

    onRender: ->
      @grid.show(new Grid({
        collection: @collection
        editable: @
        defaultEmptyText: window.RetailTracker.i18n.warehouseEmptyList
        withoutHeader: true
        columns: [
          {
            field: 'name'
            placeholder: window.RetailTracker.i18n.name
            type: 'string'
            width: 250
          }
          {
            field: 'address'
            placeholder: window.RetailTracker.i18n.address
            type: 'string'
          }
        ]
      }))