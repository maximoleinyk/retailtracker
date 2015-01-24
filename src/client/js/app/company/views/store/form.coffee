define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  i18n = require('cs!app/common/i18n')
  select = require('select')

  Layout.extend

    template: require('hbs!./form.hbs')
    className: 'page page-2thirds'

    templateHelpers: ->
      isNew: @model.isNew()

    onRender: ->
      @renderManagerSelect()
      @renderWarehouseSelect()
      @renderPriceListSelect()

    employeeFormatter: (obj) =>
      if obj.text then obj.text else obj.firstName + ' ' + obj.lastName + ' ' + obj.email

    warehouseFormatter: (obj) =>
      if obj.text then obj.text else obj.name

    priceListFormatter: (obj) =>
      if obj.text then obj.text else obj.name

    renderPriceListSelect: ->
      select(@ui.$priceListSelect, {
        id: (priceList) ->
          return priceList._id
        ajax:
          url: '/pricelist/select/fetch'
          dataType: 'jsonp'
          quietMillis: 150,
          data: (term) ->
            q: term
          results: (data) ->
            results: data
        formatSelection: @priceListFormatter
        formatResult: @priceListFormatter
        initSelection: (element, callback) =>
          obj = @model.get('priceList') or {}
          callback(obj)
          @model.set('priceList', obj._id)
      })
      @ui.$priceListSelect.select2('val', @model.get('priceList')) if @model.get('priceList')

    renderWarehouseSelect: ->
      select(@ui.$warehouseSelect, {
        id: (warehouse) ->
          return warehouse._id
        ajax:
          url: '/warehouse/select/fetch'
          dataType: 'jsonp'
          quietMillis: 150,
          data: (term) ->
            q: term
          results: (data) ->
            results: data
        formatSelection: @warehouseFormatter
        formatResult: @warehouseFormatter
        initSelection: (element, callback) =>
          obj = @model.get('warehouse')
          callback(obj)
          @model.set('warehouse', obj._id)
      })
      @ui.$managerSelect.select2('val', @model.get('warehouse')) if @model.get('warehouse')

    renderManagerSelect: ->
      select(@ui.$managerSelect, {
        id: (employee) ->
          return employee._id
        ajax:
          url: '/employees/select/fetch'
          dataType: 'jsonp'
          quietMillis: 150,
          data: (term) ->
            q: term
          results: (data) ->
            results: data
        formatSelection: @employeeFormatter
        formatResult: @employeeFormatter
        initSelection: (element, callback) =>
          obj = @model.get('manager')
          callback(obj)
          @model.set('manager', obj._id)
      })
      @ui.$managerSelect.select2('val', @model.get('manager')) if @model.get('manager')
