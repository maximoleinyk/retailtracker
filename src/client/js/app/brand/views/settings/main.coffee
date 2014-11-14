define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  Settings = require('cs!app/brand/models/settings')
  UserInfo = require('util/userInfo')
  ProfileView = require('cs!./profile')
  SecurityView = require('cs!./security')

  Layout.extend

    template: require('hbs!./main')
    className: 'container'

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
      @navigateTo('settings/profile')

