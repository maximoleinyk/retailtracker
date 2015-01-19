define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  InviteeList = require('cs!./inviteeList')
  _ = require('underscore')
  Collection = require('cs!app/common/collection')

  Layout.extend

    template: require('hbs!./edit.hbs')
    className: 'page page-2thirds company'

    onRender: ->
      @renderInviteeList()
      @renderSelect()

    templateHelpers: ->
      url: '/company/' + @model.id + '/employees'
      isNew: @model.isNew()
      currencyCodes: =>
        _.map @options.currencies, (object) ->
          id: object.iso.code
          text: object.iso.code

    renderInviteeList: ->
      @inviteeList.show new InviteeList({
        collection: new Collection(@model.get('invitees'), {parse:true})
        model: @model
        roles: @options.roles
      })

    renderSelect: ->
      @ui.$select.select2()
      @ui.$select.select2('enable', false)

    save: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.update()
      .then =>
        @navigateTo('/companies')
      .catch (err) =>
        @validation.show(err)
