define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  EmployeeList = require('cs!./employeeList')
  currencies = require('util/currencies')
  _ = require('underscore')
  Collection = require('cs!app/common/mongoCollection')

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
        collection: new Collection(@model.get('invitees'), {parse:true})
        model: @model
      })

    renderSelect: ->
      @ui.$select.select2()
      @ui.$select.select2('enable', false)

    cancel: ->
      @navigateTo('')

    update: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.update()
      .then =>
        @navigateTo('')
      .then null, (err) =>
        @validation.show(err)
