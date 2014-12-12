define (require) ->
  'use strict'

  Marionette = require('marionette')
  http = require('util/http')
  context = require('cs!app/common/context')
  Crypto = require('crypto')

  Marionette.ItemView.extend

    template: require('hbs!./header.hbs')
    tagName: 'header'

    initialize: ->
      @model = context
      @listenTo(context, 'change:owner.firstName', @updateNameLabel, @)
      @listenTo(context, 'change:owner.lastName', @updateNameLabel, @)

    onRender: ->
      @updateNameLabel()

    templateHelpers: ->
      email = context.get('login').trim().toLowerCase()
      {
      avatarSrc: 'http://www.gravatar.com/avatar/' + new Crypto.MD5().hex(email)
      }

    updateNameLabel: ->
      @ui.$userName.text(@model.get('owner.firstName') + ' ' + @model.get('owner.lastName'))

    logout: ->
      http.del '/security/logout', ->
        window.location.reload()