define ['cs!app/common/baseController', 'cs!app/landing/view/dashboard/top'], (BaseController, LandingPage) ->
  'use strict'

  BaseController.extend
    index: ->
      @eventBus.trigger 'open:page', new LandingPage
