define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  Grid = require('util/grid/main')
  _ = require('underscore')
  context = require('cs!app/common/context')

  Layout.extend

    template: require('hbs!./list')
    className: 'container'

    onRender: ->
      @renderGrid()

    renderGrid: ->
      @grid.show new Grid({
        collection: @options.collection
        defaultEmptyText: window.RetailTracker.i18n.nomenclatureEmptyGridText
        columns: [
          {
            field: 'name'
            title: window.RetailTracker.i18n.name
            type: 'string'
          }
        ]
      })