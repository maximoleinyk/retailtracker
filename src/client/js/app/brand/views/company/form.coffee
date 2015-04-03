define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  InviteeList = require('cs!./inviteeList')
  _ = require('underscore')
  Collection = require('cs!app/common/collection')

  Layout.extend

    template: require('hbs!./form.hbs')
    className: 'page page-halves'

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
        collection: new Collection(@model.get('invitees'), {parse: true})
        model: @model
        roles: @options.roles
      })

    renderSelect: ->
      @ui.$select.selectBox().select2('enable', false) if not this.model.isNew()

    submit: ->
      @model.save().then =>
        @navigateTo('/companies')
