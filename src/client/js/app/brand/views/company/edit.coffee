define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  EmployeeList = require('cs!./employeeList')
  currencies = require('util/currencies')
  _ = require('underscore')
  Employees = require('cs!app/company/collections/employees')

  Layout.extend

    template: require('hbs!./edit')
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
        collection: new Employees(@model.get('employees').concat(@model.get('invitees')), {parse:true})
      })

    renderSelect: ->
      @ui.$select.select2()
      @ui.$select.select2('enable', false)

    cancel: ->
      @navigate('')

    update: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.update()
      .then =>
        @navigate('')
      .then null, (err) =>
        @validation.show(err)
