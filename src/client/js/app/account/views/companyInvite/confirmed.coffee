define (require) ->
  'use strict'

  Marionette = require('marionette')
  Marionette.ItemView.extend

    template: require('hbs!./confirmed')

    templateHelpers: ->
      {
      company: @options.company.toJSON()
      }
