define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  InviteList = require('cs!./inviteList')
  currencies = require('util/currencies')
  _ = require('underscore')

  Layout.extend

    template: require('hbs!./edit')
    className: 'container'

    onRender: ->
      @renderInvitees()
      @renderSelect()

    templateHelpers: ->
      currencyCodes: ->
        _.map currencies, (object) ->
          id: object.iso.code
          text: object.iso.code

    renderInvitees: ->
      @inviteList.show new InviteList({
        model: @model
      })

    renderSelect: ->
      @ui.$select.select2()

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
