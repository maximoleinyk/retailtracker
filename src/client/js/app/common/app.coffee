define (require) ->
  'use strict'

  Marionette = require('marionette')
  Layout = require('cs!app/common/view/layout')

  Marionette.Renderer.render = (compile, data) -> compile data

  new Layout().render()
  new Marionette.Application
