define (require) ->
  'use strict'

  Marionette = require('marionette')
  Grid = require('util/grid/main')

  class UomList extends Marionette.Layout

    template: require('hbs!./main')

    regions:
      grid: '[data-id="grid"]'

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
        editable: true
        onCreate: _.bind(@onCreate, @)
        onSave: _.bind(@onSave, @)
        onDelete: _.bind(@onDelete, @)
        onCancel: _.bind(@onCancel, @)
        columns: [
          {
            field: 'name'
            title: window.RetailTracker.i18n.name
            type: 'string'
            width: 250
          }
          {
            field: 'description'
            title: window.RetailTracker.i18n.description
            type: 'string'
          }
        ]
      }))