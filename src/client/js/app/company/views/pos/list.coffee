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
        defaultEmptyText: i18n.get('listOfPosItemsIsEmpty')
        columns: [
          {
            field: 'name'
            title: i18n.get('name')
            url: (model) ->
              '/pos/' + model.id
          },
          {
            field: 'store'
            title: i18n.get('store')
            url: (model) ->
              '/stores/' + model.get('store._id')
            formatter: (storeObject) ->
              storeObject.name
          },
          {
            field: 'description'
            title: i18n.get('description')
          }
        ]
      })
