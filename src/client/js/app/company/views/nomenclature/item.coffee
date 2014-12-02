define (require) ->
  'use strict'

  Marionette = require('marionette')

  Marionette.ItemView.extend

    template: require('hbs!./item')

    delete: ->
      @model.delete().then =>
        @model.trigger('destroy', @model, @model.collection);
