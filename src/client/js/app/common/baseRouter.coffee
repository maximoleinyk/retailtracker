define (require) ->
  'use strict'

  Marionette = require('marionette')
  NotFound = require('cs!app/common/view/notFound')

  Marionette.AppRouter.extend

    routes:
      '*404': 'notFound'

    notFound: ->
      @eventBus.trigger 'open:page', new NotFound