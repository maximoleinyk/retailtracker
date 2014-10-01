define (require) ->
  'use strict'

  Marionette = require('marionette')
  Settings = require('cs!app/admin/models/settings')
  UserInfo = require('util/userInfo')
  ProfileView = require('cs!./profile')
  SecurityView = require('cs!./security')

  Marionette.Layout.extend

    template: require('hbs!./main')

    regions:
      content: '[data-id="content"]'

    initialize: (options) ->
      @view = options.view
      @model = new Settings({
        id: UserInfo.get('_id')
      })

    onRender: ->
      switch @view
        when 'profile' then @profileView()
        when 'security' then @securityView()
        else @defaultView()

    profileView: ->
      @model.set
        firstName: UserInfo.get('firstName')
        lastName: UserInfo.get('lastName')
      @content.show(new ProfileView({
        model: @model
      }))

    securityView: ->
      @content.show(new SecurityView({
        model: @model
      }))

    defaultView: ->
      @eventBus.trigger('router:navigate', 'settings/profile', {trigger: true})

