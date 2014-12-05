define (require) ->
  'use strict'

  Marionette = require('marionette')

  Marionette.ItemView.extend

    template: require('hbs!./view.hbs')
    className: 'container nomenclature'

    onRender: ->
      @ui.$removeButton.tooltip()