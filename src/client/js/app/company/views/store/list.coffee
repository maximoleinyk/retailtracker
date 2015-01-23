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
        defaultEmptyText: i18n.get('listOfStoresIsEmpty')
        columns: [
          {
            field: 'name'
            title: i18n.get('name')
            url: (model) ->
              '/stores/' + model.id
          }
        ]
      })
