define (require) ->
  'use strict'

  App = require('cs!app/common/app')
  require('cs!app/landing/router')

  App.start()
