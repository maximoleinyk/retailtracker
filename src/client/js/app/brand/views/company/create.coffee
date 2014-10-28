define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  EmployeeList = require('cs!./employeeList')
  currencies = require('util/currencies')
  _ = require('underscore')
  Employees = require('cs!app/company/collections/employees')

  Layout.extend

    template: require('hbs!./create')
    className: 'container'

    onRender: ->
      @renderEmployeeList()
      @renderSelect()

    templateHelpers: ->
      currencyCodes: ->
        _.map currencies, (object) ->
          id: object.iso.code
          text: object.iso.code

    renderEmployeeList: ->
      @employeeList.show new EmployeeList({
        collection: new Employees()
      })

    renderSelect: ->
      @ui.$select.select2()

    cancel: ->
      @navigate('')

    create: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.create()
      .then =>
        @navigate('')
      .then null, (err) =>
        @validation.show(err)
