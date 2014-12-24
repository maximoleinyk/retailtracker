define (require) ->
  'use strict'

  CompositeView = require('cs!app/common/marionette/compositeView')
  ItemView = require('cs!./item')

  CompositeView.extend

    template: require('hbs!./list.hbs')
    className: 'page nomenclature'
    itemViewContainer: '[data-id="listContainer"]'
    itemView: ItemView

    templateHelpers: ->
      isEmptyCollection: @collection.length is 0
