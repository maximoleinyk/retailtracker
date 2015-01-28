define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  context = require('cs!app/common/context')
  ProfileView = require('cs!./profile')
  SecurityView = require('cs!./security')

  Layout.extend

    template: require('hbs!./main.hbs')
    className: 'page page-2thirds'

    initialize: (options) ->
      @view = options.view

    onRender: ->
      switch @view
        when 'profile' then @profileView()
        when 'security' then @securityView()
        else
          @navigateTo('settings/profile')
      $('.app > .content-wrapper').removeClass('box-like')

    profileView: ->
      @content.show(new ProfileView)

    securityView: ->
      @content.show(new SecurityView({
        model: @model
      }))

    back: (e) ->
      e.preventDefault();
      @navigateTo('')
