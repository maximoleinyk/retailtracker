define (require) ->
  'use strict'

  i18n = require('cs!app/common/i18n')
  Grid = require('app/common/grid/main')
  helpers = require('app/common/helpers')

  (options) ->
    new Grid
      collection: options.collection
      defaultEmptyText: i18n.get('emptyGoodsReceiveList')
      editable: options.crud
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

          formatResult: (object) =>
            if object.text then object.text else object.name
          formatter: (object) ->
            object?.name
        },
        {
          field: 'remainingCommodity'
          title: i18n.get('remainingCommodity')
          width: 100
          readonly: true
          type: 'number'
        },
        {
          field: 'quantity'
          title: i18n.get('quantity')
          width: 100
          type: 'number'
        },
        {
          field: 'price'
          title: i18n.get('price')
          width: 150
          type: 'number'
        }
        {
          field: 'totalPrice'
          title: i18n.get('totalPrice')
          width: 150
          type: 'number'
        }
      ]
