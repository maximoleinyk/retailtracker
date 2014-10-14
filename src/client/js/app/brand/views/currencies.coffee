define (require) ->
  'use strict'

  Marionette = require('marionette')
  Grid = require('util/grid/main')

  class Currencies extends Marionette.Layout

    template: require('hbs!./currencies')

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
      @grid.show new Grid({
        collection: @collection
        editable: @
        defaultEmptyText: 'Вы еще не создали ни одной валюты'
        columns: [
          {
            field: 'name'
            title: window.RetailTracker.i18n.name
            type: 'string'
          }
          {
            field: 'code'
            title: window.RetailTracker.i18n.code
            type: 'string'
            width: 300
          }
          {
            field: 'rate'
            title: window.RetailTracker.i18n.rate
            type: 'string'
            width: 200
          }
        ]
      })