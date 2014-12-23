define (require) ->
  'use strict'

  Marionette = require('marionette')
  http = require('app/common/http')
  context = require('cs!app/common/context')
  md5 = require('md5')

  Marionette.ItemView.extend

    template: require('hbs!./header.hbs')

    initialize: ->
      @model = context
      @listenTo(context, 'change:owner.firstName', @updateNameLabel, @)
      @listenTo(context, 'change:owner.lastName', @updateNameLabel, @)

    onRender: ->
      @updateNameLabel()

    templateHelpers: ->
      avatarSrc: 'http://www.gravatar.com/avatar/' + md5(context.get('login').trim().toLowerCase())
      companyName: context.get('company.name')

    updateNameLabel: ->
      firstName = @model.get('owner.firstName')
      lastName = @model.get('owner.lastName')
      @ui.$userName.text("#{firstName} #{lastName}")

    logout: ->
      http.del '/security/logout', =>
        @eventBus.trigger('module:load', 'account', 'login')

    openBrand: ->
      @eventBus.trigger('module:load', 'brand')