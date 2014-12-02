define (require) ->
  'use strict'

  Marionette = require('marionette')
  ItemView = require('cs!./item')

  Marionette.CompositeView.extend

    template: require('hbs!./list')
    className: 'container'
    itemViewContainer: '[data-id="listContainer"]'
    itemView: ItemView

    templateHelpers: ->
      {
      isEmptyCollection: @collection.length is 0
      }