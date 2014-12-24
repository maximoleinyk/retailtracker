define (require) ->
  'use strict'

  Marionette = require('marionette')
  ItemView = require('cs!app/common/marionette/itemView')
  d3 = require('d3')
  _ = require('underscore')

  ItemView.extend

    template: require('hbs!./dashboard.hbs')
    className: 'page page-halves'

    onRender: ->
      Marionette.$.getJSON '/generate/data', (data) =>
        # do nothing