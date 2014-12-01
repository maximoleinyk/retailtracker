define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  Grid = require('util/grid/main')
  Collection = require('cs!app/common/mongoCollection')

  Layout.extend

    template: require('hbs!./attributes')

    initialize: ->
      @collection = new Collection(@model.get('attributes'), {parse: true})

    onRender: ->
      @wrapper.show new Grid({
        collection: @collection
        withoutHeader: true
        columns: [
          {
            field: 'key'
            type: 'string'
            width: 175
          },
          {
            field: 'value'
            type: 'string'
          }
        ]
        editable: @
        skipInitialAutoFocus: true
      })

    update: ->
      @model.set('attributes', @collection.toJSON())

    onCreate: (attribute, callback) ->
      return callback({ key: window.RetailTracker.i18n.enterKey }) if not attribute.get('key')
      return callback({ value: window.RetailTracker.i18n.enterValue }) if not attribute.get('value')
      attribute.commit()
      @collection.add(attribute)
      @update()
      callback()

    onSave: (attribute, callback) ->
      return callback({ key: window.RetailTracker.i18n.enterKey }) if not attribute.get('key')
      return callback({ value: window.RetailTracker.i18n.enterValue }) if not attribute.get('value')
      attribute.commit()
      @update()
      callback()

    onCancel: (attribute, callback) ->
      attribute.reset()
      callback()

    onDelete: (attribute, callback) ->
      @collection.remove(attribute)
      @update()
      callback()