define (require) ->
  'use strict'

  Marionette = require('marionette')
  mixin = require('cs!./mixin')

  Marionette.Layout.extend(mixin(Marionette.Layout)).extend

    constructor: ->
      @listenTo(this, 'render', this.initRegions, this)
      super

    initRegions: ->
      @$el.find('[data-region]').each (index, el) ->
        dataRegion = Marionette.$(el).attr('data-region')
        regionName = '[data-region="' + dataRegion + '"]'
        @addRegion(dataRegion, regionName) if not Marionette.getOption(@, 'regions')[dataRegion]
