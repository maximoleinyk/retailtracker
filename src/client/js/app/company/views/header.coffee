define (require) ->
  'use strict'

  Marionette = require('marionette')
  http = require('util/http')
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

    updateNameLabel: ->
      @ui.$userName.text(@model.get('owner.firstName') + ' ' + @model.get('owner.lastName'))

    logout: ->
      http.del '/security/logout', ->
        window.location.reload()