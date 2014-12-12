define (require) ->
  'use strict'

  Marionette = require('marionette')

  Marionette.ItemView.extend

    template: require('hbs!./view.hbs')
    className: 'page page-2thirds nomenclature'

    onRender: ->
      @ui.$removeButton.tooltip()