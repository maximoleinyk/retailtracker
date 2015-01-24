define (require) ->
  'use strict'

  Layout = require('app/common/marionette/layout')

  Layout.extend

    template: require('hbs!./choose.hbs')
    className: 'page page-box'

    onRender: ->
      @applyClassSelector()

    applyClassSelector: ->
      $('.app > .content-wrapper').addClass('box-like')
