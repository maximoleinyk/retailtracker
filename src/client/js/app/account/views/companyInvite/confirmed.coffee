define (require) ->
  'use strict'

  Marionette = require('marionette')
  Marionette.ItemView.extend

    template: require('hbs!./confirmed.hbs')
    className: 'page page-box'

    templateHelpers: ->
      company: @options.company.toJSON()
