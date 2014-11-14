define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  EmployeeList = require('cs!./employeeList')
  currencies = require('util/currencies')
  _ = require('underscore')
  Collection = require('cs!app/common/mongoCollection')

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
        collection: new Collection()
        model: @model
      })

    renderSelect: ->
      @ui.$select.select2()

    cancel: ->
      @navigateTo('')

    create: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.create()
      .then =>
        @navigateTo('')
      .then null, (err) =>
        @validation.show(err)
