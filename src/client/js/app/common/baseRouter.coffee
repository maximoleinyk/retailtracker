define ['marionette', 'cs!app/common/view/notFound/top'], (Marionette, NotFound) ->
  'use strict'

  Marionette.AppRouter.extend

    routes:
      '*404': 'notFound'

    notFound: ->
      @eventBus.trigger 'open:page', new NotFound