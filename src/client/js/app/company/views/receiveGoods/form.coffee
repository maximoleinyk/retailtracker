define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  i18n = require('cs!app/common/i18n')
  select = require('app/common/select')
  Grid = require('cs!./grid')
  Collection = require('cs!app/common/collection')

  Layout.extend

    template: require('hbs!./form.hbs')
    className: 'page page-halves'

    onRender: ->
      @renderWarehouseSelect()
      @renderEmployeeSelect()
      @renderCurrencySelect()
      @renderGrid()

    onCreate: (model, callback) ->
      callback()

    onSave: (model, callback) ->
      callback()

    onCancel: (model, callback) ->
      callback()

    onRemove: (model, callback) ->
      callback()

    renderGrid: ->
      @grid.show new Grid
        collection: new Collection(@model.get('items'))
        crud: this

    renderCurrencySelect: ->
      currencyObject = @model.get('currency')
      select @ui.$currencySelect,
        urlRoot: '/currency'
        format: 'currency'
        createRoute: '/currency'
        initSelection: (element, callback) =>
          callback(currencyObject)
      @model.set('currency', currencyObject._id, {silent: true}) if @model.get('currency')

    renderWarehouseSelect: ->
      warehouseObject = @model.get('warehouse')
      select @ui.$warehouseSelect,
        urlRoot: '/warehouse'
        format: 'warehouse'
        initSelection: (element, callback) =>
          callback(warehouseObject)
      @model.set('warehouse', warehouseObject._id, {silent: true}) if @model.get('warehouse')

    renderEmployeeSelect: ->
      employee = @model.get('assignee')
      select(@ui.$assigneeSelect, {
        format: 'employee'
        urlRoot: '/employees'
        initSelection: (element, callback) =>
          callback(employee)
      })
      @model.set('manager', employee._id, {silent: true}) if @model.get('assignee')

    submit: ->
      @model.save().then =>
        # navigate to the next step
