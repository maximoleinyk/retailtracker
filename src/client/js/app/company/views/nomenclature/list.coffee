define (require) ->
  'use strict'

  Marionette = require('marionette')

  Marionette.ItemView.extend

    template: require('hbs!./list')
    className: 'container'

    templateHelpers: ->
      {
        items: @options.collection.toJSON()
      }