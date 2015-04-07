define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  i18n = require('cs!app/common/i18n')
  Grid = require('cs!./grid')
  Collection = require('cs!app/common/collection')
  helpers = require('app/common/helpers')

  Layout.extend

    template: require('hbs!./form.hbs')
    className: 'page page-halves page-2thirds'

    modelEvents:
      'change:totalPrice': 'updateTotals'
      'change:currency': 'updateTotals'

    initialize: ->
      @items = new Collection

    templateHelpers: ->
      isEntered: @model.isEntered()

    onRender: ->
      @renderWarehouseSelect()
      @renderCurrencySelect()
      @renderGrid()
      @updateTotals()

    renderWarehouseSelect: ->
      warehouseObject = @model.get('warehouse')
      @ui.$warehouseSelect.selectBox
        urlRoot: '/warehouse'
        format: 'warehouse'
        route: '/warehouses'
        initSelection: (element, callback) =>
          callback(warehouseObject)
      @model.set('warehouse', warehouseObject._id, {silent: true}) if @model.get('warehouse')

    renderCurrencySelect: ->
      currencyObject = @model.get('currency')
      @ui.$currencySelect.selectBox
        urlRoot: '/currency'
        route: '/currency'
        format: 'currency'
        initSelection: (element, callback) =>
          callback(currencyObject)
        onSelection: (id, object) =>
          @model.set({
            currencyRate: object.rate
            currencyCode: object.code
          })
      @model.set('currency', currencyObject._id, {silent: true}) if @model.get('currency')

    renderGrid: ->
      options =
        collection: @items
      options.crud = this if not @model.isEntered()
      @items.reset(@model.get('items'))
      @grid.show new Grid(options)

    updateTotals: ->
      @ui.$resultPrice.text(helpers.amount(@model.get('totalPrice'), @model.get('currencyCode')))
      @ui.$currencyRate.text(helpers.currencyRate(@model.get('currencyRate')))
      @ui.$resultAmount.text(@model.get('items').length)

    save: ->
      @model.save().then =>
        @navigateTo('/goods/receive')

    handleErrors: (model) ->
      errors = {}
      errors.nomenclature = i18n.get('nomenclatureIsRequired') if not model.get('nomenclature')
      errors.nomenclature = i18n.get('nomenclatureAlreadyExistsInList') if model.get('nomenclature') and @items.pluck('nomenclature._id').indexOf(model.get('nomenclature')) > -1
      errors.quantity = i18n.get('quantityShouldBeSpecified') if not model.get('quantity')
      errors.price = i18n.get('priceShouldBeSpecified') if not model.get('price')
      errors

    enter: ->
      @model.enter().then =>
        @render()

    onCreate: (model, callback) ->
      errors = @handleErrors(model)
      return callback(errors) if not _.isEmpty(errors)

      @model.get('items').push(model.toJSON())
      @model.updateTotals().then =>
        _.each @model.get('items'), (item) ->
          return if not _.isObject(item.nomenclature)
          if item.nomenclature._id is model.get('nomenclature')
            model.set(item, {parse: true})
          item.nomenclature = item.nomenclature._id
        @items.add(model)
        callback()
      .catch ->
        callback(model.get('errors'))
      @ui.$gridGroup.removeClass('has-error').find('.help-block').text('')

    onSave: (model, callback) ->
      errors = @handleErrors(model)
      return callback(errors) if not _.isEmpty(errors)

      _.each @model.get('items'), (item) ->
        if item.nomenclature is model.get('nomenclature._id')
          updatedData = model.toJSON()
          item.nomenclature = updatedData.nomenclature._id
          item.quantity = updatedData.quantity
          item.price = updatedData.price
          item.totalPrice = updatedData.totalPrice

      @model.updateTotals().then =>
        _.each @model.get('items'), (item) ->
          if _.isObject(item.nomenclature)
            if item.nomenclature._id is model.get('nomenclature')
              model.set(item, {parse: true})
            item.nomenclature = item.nomenclature._id
        callback()
      .catch ->
        callback(model.get('errors'))

    onCancel: (model, callback) ->
      found = _.find @model.get('items'), (item) ->
        item.nomenclature is model.get('nomenclature._id')
      if found && _.isObject(model.get('nomenclature'))
        model.set(_.extend(_.clone(found), {
          nomenclature: model.get('nomenclature')
        }))
      callback()

    onDelete: (model, callback) ->
      @items.remove(model)
      @model.set('items', @items.toJSON())
      _.each @model.get('items'), (item) ->
        if item.nomenclature is model.get('nomenclature._id')
          updatedData = model.toJSON()
          item.nomenclature = updatedData.nomenclature._id
          item.quantity = updatedData.quantity
          item.price = updatedData.price
          item.totalPrice = updatedData.totalPrice
      @model.updateTotals().then =>
        callback()
      .catch ->
        callback(model.get('errors'))
