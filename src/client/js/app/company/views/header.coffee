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
      avatarSrc: avatar(context.get('account.login'))
      companyName: context.get('company.name')

    updateNameLabel: ->
      firstName = @model.get('account.owner.firstName')
      lastName = @model.get('account.owner.lastName')
      @ui.$userName.text("#{firstName} #{lastName}".trim())

    logout: ->
      http.del '/security/logout', =>
        @eventBus.trigger('module:load', 'account', 'login')

    openBrand: ->
      @eventBus.trigger('module:load', 'brand')
