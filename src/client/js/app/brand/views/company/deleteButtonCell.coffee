define (require) ->
  'use strict'

  AbstractCell = require('util/grid/table/cells/abstractCell')
  context = require('cs!app/common/context')

  AbstractCell.extend

    template: require('hbs!./deleteButtonCell')

    templateHelpers: ->
      isOwner: @options.model.id is context.get('owner')._id

    removeEmployee: ->
      @options.employees.remove(@options.model)
      @options.company.set('employees', @options.employees.toJSON())
