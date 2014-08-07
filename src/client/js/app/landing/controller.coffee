define (require) ->
  'use strict'

  BaseController = require('cs!app/common/baseController');
  LandingPage = require('cs!app/landing/view/dashboard')

  BaseController.extend
    index: ->
      @eventBus.trigger 'open:page', new LandingPage
