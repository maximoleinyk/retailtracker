define (require) ->
  'use strict'

  i18n = require('cs!app/common/i18n')
  Grid = require('app/common/grid/main')
  helpers = require('app/common/helpers')
  numeral = require('numeral')

  (options) ->
    new Grid
      collection: options.collection
      defaultEmptyText: i18n.get('emptyGoodsReceiveList')
      editable: options.crud
      skipInitialAutoFocus: true
      columns: [
        {
          field: 'nomenclature'
          title: i18n.get('nomenclature')
          placeholder: i18n.get('selectNomenclature')
          type: 'select'
          limit: 5
          ajaxUrl: '/nomenclature/select/fetch'
          url: (model) ->
            '/nomenclature/' + model.get('nomenclature._id')
          onSelection: (object, model) ->
            model.set({
              price: 0
              quantity: 0
              totalPrice: 0
            })
          formatResult: (object) =>
            if object.text then object.text else object.name
          formatter: (object) ->
            object?.name
        },
        {
          field: 'quantity'
          title: i18n.get('quantity')
          width: 100
          type: 'number'
          default: 0
          events:
            blur: (value, model, done) ->
              model.set('totalPrice', numeral(model.get('price')).multiply(+model.get('quantity')).value())
              done()
        },
        {
          field: 'price'
          title: i18n.get('price')
          width: 150
          type: 'number'
          default: 0
          formatter: (value) ->
            helpers.money(value);
          events:
            blur: (value, model, done) ->
              model.set('totalPrice', numeral(model.get('price')).multiply(+model.get('quantity')).value())
              done()
        }
        {
          field: 'totalPrice'
          title: i18n.get('totalPrice')
          width: 150
          type: 'number'
          readonly: true
          default: 0
          formatter: (value) ->
            helpers.money(value);
        }
      ]
