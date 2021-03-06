define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  Collection = require('cs!app/common/collection')
  i18n = require('cs!app/common/i18n')

  Layout.extend

    template: require('hbs!./attributes.hbs')

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
      return callback({ key: i18n.get('enterKey') }) if not attribute.get('key')
      return callback({ value: i18n.get('enterValue') }) if not attribute.get('value')
      attribute.commit()
      @collection.add(attribute)
      @update()
      callback()

    onSave: (attribute, callback) ->
      return callback({ key: i18n.get('enterKey') }) if not attribute.get('key')
      return callback({ value: i18n.get('enterValue') }) if not attribute.get('value')
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