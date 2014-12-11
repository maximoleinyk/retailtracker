define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  InviteeList = require('cs!./inviteeList')
  currencies = require('util/currencies')
  _ = require('underscore')
  Collection = require('cs!app/common/mongoCollection')

  Layout.extend

    template: require('hbs!./create.hbs')
    className: 'page page-2thirds'
    tagName: 'form'
    attributes: {
      'data-submit': 'create'
    }

    onRender: ->
      @renderInviteeList()
      @renderSelect()

    templateHelpers: ->
      isNew: @model.isNew()
      currencyCodes: ->
        _.map currencies, (object) ->
          id: object.iso.code
          text: object.iso.code

    renderInviteeList: ->
      @inviteeList.show new InviteeList({
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
