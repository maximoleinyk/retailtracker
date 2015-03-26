define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')

  Layout.extend
    template: require('hbs!./dashboard.hbs')
