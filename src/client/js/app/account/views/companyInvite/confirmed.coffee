define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  ItemView.extend

    template: require('hbs!./confirmed.hbs')
    className: 'page page-box'

    templateHelpers: ->
      company: @options.company.toJSON()
