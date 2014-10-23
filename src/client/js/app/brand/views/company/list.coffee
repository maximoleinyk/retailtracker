define (require) ->
  'use strict'

  Marionette = require('marionette')
  ItemView = require('cs!./item')

  Marionette.CompositeView.extend

    template: require('hbs!./list')
    itemView: ItemView
    className: 'company-list'