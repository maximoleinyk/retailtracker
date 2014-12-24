define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')

  ItemView.extend

    template: require('hbs!./view.hbs')
    className: 'page page-2thirds nomenclature'

    onRender: ->
      @ui.$removeButton.tooltip()