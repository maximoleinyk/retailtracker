define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  InviteeList = require('cs!./inviteeList')
  EmployeeList = require('cs!./employeeList')
  currencies = require('util/currencies')
  _ = require('underscore')
  Collection = require('cs!app/common/mongoCollection')

  Layout.extend

    template: require('hbs!./edit.hbs')
    className: 'page page-2thirds'

    onRender: ->
      @renderEmployeeList()
      @renderInviteeList()
      @renderSelect()

    templateHelpers: ->
      isNew: @model.isNew()
      currencyCodes: ->
        _.map currencies, (object) ->
          id: object.iso.code
          text: object.iso.code

    renderEmployeeList: ->
      @employeeList.show new EmployeeList({
        collection: new Collection(@model.get('employees'), {parse:true})
        model: @model
      })

    renderInviteeList: ->
      @inviteeList.show new InviteeList({
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
