define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  http = require('app/common/http')
  context = require('cs!app/common/context')
  md5 = require('md5')

  ItemView.extend

    template: require('hbs!./header.hbs')

    initialize: ->
      @model = context
      @listenTo(context, 'change:owner.firstName', @updateNameLabel, @)
      @listenTo(context, 'change:owner.lastName', @updateNameLabel, @)

    onRender: ->
      @updateNameLabel()

    templateHelpers: ->
      isDependantAccount: context.get('dependsFrom')
      avatarSrc: 'http://www.gravatar.com/avatar/' + md5(context.get('login').trim().toLowerCase())

    updateNameLabel: ->
      firstName = @model.get('owner.firstName')
      lastName = @model.get('owner.lastName')
      @ui.$userName.text("#{firstName} #{lastName}".trim())

    logout: ->
      http.del '/security/logout', =>
        @eventBus.trigger('module:load', 'account', 'login')
