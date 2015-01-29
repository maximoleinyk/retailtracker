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
      @listenTo(context, 'change:account.owner.firstName', @updateNameLabel, this)

    onRender: ->
      @updateNameLabel()

    templateHelpers: ->
      avatarSrc: avatar(context.get('account.login'))
      companyName: context.get('company.name')
      isCashier: context.get('employee.role.name') is 'CASHIER'

    updateNameLabel: ->
      @ui.$userName.text(@model.get('account.owner.firstName'))

    logout: ->
      http.del '/security/logout', =>
        @eventBus.trigger('module:load', 'account', 'login')

    openBrand: ->
      @eventBus.trigger('module:load', 'brand')
