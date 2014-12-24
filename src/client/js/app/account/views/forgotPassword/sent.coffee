define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')

  ItemView.extend
    template: require('hbs!./sent.hbs')
    className: 'page page-box'
