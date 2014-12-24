define (require) ->
  'use strict'

  Marionette = require('marionette')
  mixin = require('./mixin')

  Marionette.Layout.extend(mixin(Marionette.Layout)).extend

    constructor: ->
      @listenTo(this, 'render', this.initRegions, this)
      Marionette.Layout::constructor.apply(this, arguments)

    initRegions: ->
      @$el.find('[data-region]').each (index, el) =>
        dataRegion = Marionette.$(el).attr('data-region')
        regionName = '[data-region="' + dataRegion + '"]'
        regions = Marionette.getOption(@, 'regions')
        @regions = regions = {} if not regions
        @addRegion(dataRegion, regionName)if not regions[dataRegion]