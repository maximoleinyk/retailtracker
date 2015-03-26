define (require) ->
  'use strict'

  ItemView = require('app/common/marionette/itemView')

  ItemView.extend

    template: require('hbs!./actionCell.hbs')
    tagName: 'td'

    initialize: ->
      @row = @options.cellManager

    destroy: ->
      next = (err) =>
        @row.validate err, =>
          @row.removeItem(@options.model)

      if @row.options.editable.onDelete
        @row.options.editable.onDelete(@options.model, next)
      else
        next()

