define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')

  ItemView.extend
    template: require('hbs!./success.hbs')
    className: 'page page-box'
