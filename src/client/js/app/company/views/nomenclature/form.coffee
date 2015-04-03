define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  BarcodesGrid = require('cs!./barcodes')
  AttributesGrid = require('cs!./attributes')
  _ = require('underscore')
  i18n = require('cs!app/common/i18n')

  Layout.extend

    template: require('hbs!./form.hbs')
    className: 'page page-halves'

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
      @ui.$uomSelect.selectBox
        placeholder: i18n.get('selectUom')
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
          callback(@model.get('uom'))
      @ui.$uomSelect.select2('val', @model.get('uom')) if @model.get('uom')

    renderProductGroupSelect: ->
      @ui.$productGroupSelect.selectBox
        placeholder: i18n.get('selectGroup')
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
      @ui.$productGroupSelect.select2('val', @model.get('productGroup')) if @model.get('productGroup')

    cancel: ->
      @navigateTo('')

    submit: ->
      @model.save().then =>
        @navigateTo('/nomenclature')
