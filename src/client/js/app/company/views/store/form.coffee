define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  i18n = require('cs!app/common/i18n')

  Layout.extend

    template: require('hbs!./form.hbs')
    className: 'page page-halves'

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
      priceListObject = @model.get('priceList')
      @ui.$priceListSelect.selectBox
        id: (object) ->
          return object._id
        ajax:
          url: '/pricelists/select/fetch'
          dataType: 'jsonp'
          quietMillis: 150,
          data: (term) ->
            q: term
          results: (data) ->
            results: data
        formatSelection: @priceListFormatter
        formatResult: @priceListFormatter
        initSelection: (element, callback) =>
          callback(priceListObject)
      @model.set('priceList', priceListObject._id, {silent: true}) if @model.get('priceList')

    renderWarehouseSelect: ->
      warehouseObject = @model.get('warehouse')
      @ui.$warehouseSelect.selectBox
        id: (object) ->
          return object._id
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
          callback(warehouseObject)
      @model.set('warehouse', warehouseObject._id, {silent: true}) if @model.get('warehouse')

    renderManagerSelect: ->
      managerObject = @model.get('manager')
      @ui.$managerSelect.selectBox
        id: (object) ->
          return object._id
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
          callback(managerObject)
      @model.set('manager', managerObject._id, {silent: true}) if @model.get('manager')

    submit: ->
      @model.save().then =>
        @navigateTo('/stores')
