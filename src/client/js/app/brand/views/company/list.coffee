define (require) ->
  'use strict'

  CompositeView = require('cs!app/common/marionette/compositeView')
  ItemView = require('cs!./item')

  CompositeView.extend
    template: require('hbs!./list.hbs')
    itemView: ItemView
    itemViewContainer: '[data-id="container"]'
    className: 'company-list'