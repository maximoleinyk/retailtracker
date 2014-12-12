define (require) ->
  'use strict'

  Marionette = require('marionette')
  ItemView = require('cs!./item')

  Marionette.CompositeView.extend

    template: require('hbs!./list.hbs')
    className: 'page nomenclature'
    itemViewContainer: '[data-id="listContainer"]'
    itemView: ItemView

    templateHelpers: ->
      isEmptyCollection: @collection.length is 0
