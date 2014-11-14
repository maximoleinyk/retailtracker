define (require) ->
  'use strict'

  AbstractCell = require('util/grid/table/cells/abstractCell')
  UserInfo = require('util/userInfo')

  AbstractCell.extend

    template: require('hbs!./deleteButtonCell')

    templateHelpers: ->
      isOwner: @options.model.id is UserInfo.id

    removeEmployee: ->
      @options.employees.remove(@options.model)
      @options.company.set('employees', @options.employees.toJSON())
