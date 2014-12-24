define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')

  ItemView.extend

    template: require('hbs!./completed.hbs')
    className: 'page page-box'
