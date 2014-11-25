define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  Grid = require('util/grid/main')
  currencies = require('util/currencies')
  _ = require('underscore')
  context = require('cs!app/common/context')

  Layout.extend

    template: require('hbs!./currencies')
    className: 'container'

    initialize: (options) ->
      @collection = options.collection

    onCreate: (model, callback) ->
      model.set('rate', +model.get('rate')) if not _.isNaN(+model.get('rate'))
      model.create (err, model) =>
        return callback(err) if err
        @collection.add(model)
        callback(null)

    onSave: (model, callback) ->
      model.set('rate', +model.get('rate')) if not _.isNaN(+model.get('rate'))
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
      data = _.map _.keys(currencies), (code) ->
        currency = currencies[code]
        return {
        id: currency.iso.code
        text: '(' + currency.iso.code + ') ' + currency.units.major.symbol + ' ' + currency.units.major.name
        }
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
            placeholder: window.RetailTracker.i18n.currencyType
            type: 'select'
            data: data
            formatter: (value) ->
              value
            formatResult: (json) ->
              if json.text then json.text else json.code
            onSelection: (object, model) ->
              model.set('code', object.id)
            width: 200
          }
          {
            field: 'rate'
            title: window.RetailTracker.i18n.rate
            type: 'number'
            width: 150
          }
        ],
        isActionCellVisible: (model) ->
          model.id isnt context.get('company.defaultCurrency')
      })