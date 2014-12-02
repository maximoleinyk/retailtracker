define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  BarcodesGrid = require('cs!./barcodes')
  AttributesGrid = require('cs!./attributes')
  _ = require('underscore')

  Layout.extend

    template: require('hbs!./edit')
    className: 'container'

    onRender: ->
      @renderProductGroupSelect()
      @renderUomSelect()
      @renderAttributes()
      @renderBarcodes()

    renderBarcodes: ->
      @barcodes.show(new BarcodesGrid({
        model: this.model
      }))

    renderAttributes: ->
      @attributes.show(new AttributesGrid({
        model: this.model
      }))

    uomFormatter: (modelJSON) =>
      if modelJSON.text then modelJSON.text else modelJSON.shortName

    productGroupFormatter: (modelJSON) =>
      if modelJSON.text then modelJSON.text else modelJSON.name

    renderUomSelect: ->
      @ui.$uomSelect.select2({
        placeholder: window.RetailTracker.i18n.selectUom
        id: (uomObject) ->
          return uomObject._id
        ajax:
          url: '/uom/select/fetch'
          dataType: 'jsonp'
          quietMillis: 150,
          data: (term) ->
            q: term
          results: (data) ->
            results: data
        formatSelection: @uomFormatter
        formatResult: @uomFormatter
        initSelection: (element, callback) =>
          obj = @model.get('uom')
          callback(obj)
          @model.set('uom', obj._id)
      })
      @ui.$uomSelect.select2('val', @model.get('uom')) if @model.get('uom')

    renderProductGroupSelect: ->
      @ui.$productGroupSelect.select2({
        placeholder: window.RetailTracker.i18n.selectGroup
        id: (groupObject) ->
          return groupObject._id
        ajax:
          url: '/productgroup/select/fetch'
          dataType: 'jsonp'
          quietMillis: 150,
          data: (term) ->
            q: term
          results: (data) ->
            results: data
        formatSelection: @productGroupFormatter
        formatResult: @productGroupFormatter
        initSelection: (element, callback) =>
          obj = @model.get('productGroup')
          callback(obj)
          @model.set('productGroup', obj._id)
      })
      @ui.$productGroupSelect.select2('val', @model.get('productGroup')) if @model.get('productGroup')

    cancel: ->
      @navigateTo('')

    update: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.update()
      .then =>
        @navigateTo('/nomenclature')
      .then null, (err) =>
        @validation.show(err)
