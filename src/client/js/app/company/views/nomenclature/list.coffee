define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  i18n = require('cs!app/common/i18n')

  Layout.extend

    template: require('hbs!./list.hbs')
    className: 'page'

    onRender: ->
      @grid.show new Grid({
        collection: @collection
        defaultEmptyText: 'Список номенклатур пуст'
        columns: [
          {
            field: 'name'
            title: i18n.get('name')
            url: (model) ->
              '/nomenclature/' + model.id + '/edit'
          }
          {
            field: 'article'
            title: i18n.get('article')
            width: 150
          }
          {
            field: 'productGroup.name'
            title: i18n.get('productGroup')
          }
          {
            field: 'uom.shortName'
            title: i18n.get('unitOfMeasurement')
            width: 130
          }
          {
            type: 'button'
            buttonIcon: 'fa-copy'
            buttonTypeClass: 'btn-link'
            width: 50
            action: (e, model) =>
              @navigateTo('/nomenclature/copy/' + model.id)
          }
        ]
      })
