define (require) ->
  'use strict'

  Marionette = require('marionette')

  class Layout extends Marionette.Layout

    constructor: ->
      addRegion = (index, el) =>
        $el = Marionette.$(el)
        dataRegion = $el.attr('data-region')
        regions = Marionette.getOption(@, 'regions')
        regionName = '[data-region="' + dataRegion + '"]'
        @addRegion(dataRegion, regionName) if not regions[dataRegion]

      @listenTo @, 'render', =>
        @$el.find('[data-region]').each(addRegion)

      super