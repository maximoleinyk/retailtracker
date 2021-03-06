define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  http = require('app/common/http')
  context = require('cs!app/common/context')
  avatar = require('cs!app/common/avatar')

  ItemView.extend

    template: require('hbs!./header.hbs')

    initialize: ->
      @model = context
      @listenTo(context, 'change:account.owner.firstName', @updateNameLabel, @)
      @listenTo(context, 'change:account.owner.lastName', @updateNameLabel, @)

    onRender: ->
      @updateNameLabel()

    templateHelpers: ->
      isDependantAccount: context.get('account.dependsFrom').length > 0
      avatarSrc: avatar(context.get('account.login'))

    updateNameLabel: ->
      @ui.$userName.text(@model.get('account.owner.firstName'))

    logout: ->
      http.del '/security/logout', =>
        @eventBus.trigger('module:load', 'account', 'login')
