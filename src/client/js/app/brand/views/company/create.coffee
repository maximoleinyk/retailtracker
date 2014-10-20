define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  InviteList = require('cs!./inviteList')
  currencies = require('util/currencies')
  _ = require('underscore')

  Layout.extend

    template: require('hbs!./create')

    onRender: ->
      @renderInvitees()
      @renderSelect()

    templateHelpers: ->
      currencyCodes: ->
        _.map currencies, (object) ->
            id: object.iso.code
            text: object.iso.code

    renderSelect: ->
      @ui.$select.select2()

    cancel: ->
      @navigate('')

    create: (e) ->
      e.preventDefault()

      @model.create()
      .then =>
        @navigate('')
      .then null, (err) =>

    renderInvitees: ->
      @inviteList.show new InviteList({
        model: @model
      })