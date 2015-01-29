define (require) ->
  'use strict'

  _ = require('underscore')
  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  context = require('cs!app/common/context')
  i18n = require('cs!app/common/i18n')

  Layout.extend

    template: require('hbs!./currencies.hbs')
    className: 'page'

    initialize: (options) ->
      @collection = options.collection

    onCreate: (model, callback) ->
      model.set('rate', +model.get('rate')) if not _.isNaN(+model.get('rate'))
      model.save()
      .then =>
        @options.collection.add(model)
        callback()
      .catch (model) =>
        callback(model.get('errors'))

    onSave: (model, callback) ->
      model.set('rate', +model.get('rate')) if not _.isNaN(+model.get('rate'))
      model.save()
      .then ->
        callback()
      .catch (model) ->
        callback(model.get('errors'))

    onDelete: (model, callback) ->
      model.destroy()
      .then =>
        callback()
      .catch (model) =>
        callback(model.get('errors'))

    onCancel: (model, callback) ->
      model.reset()
      callback()

    onRender: ->
      data = _.map _.keys(@options.currencies), (code) =>
        currency = @options.currencies[code]
        return {
        id: currency.iso.code
        text: '(' + currency.iso.code + ') ' + currency.units.major.symbol + ' ' + currency.units.major.name
        }
      @grid.show new Grid({
        collection: @collection
        editable: @
        defaultEmptyText: i18n.get('emptyCurrencyListMessage')
        columns: [
          {
            field: 'name'
            title: i18n.get('name')
            type: 'string'
          }
          {
            field: 'code'
            title: i18n.get('code')
            placeholder: i18n.get('currencyType')
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
            title: i18n.get('rate')
            type: 'number'
            width: 150
          }
        ],
        isActionCellVisible: (model) ->
          model.id isnt context.get('company.defaultCurrency')
      })
