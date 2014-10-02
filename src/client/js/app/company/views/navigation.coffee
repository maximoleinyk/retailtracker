define (require) ->
  'use strict'

  Marionette = require('marionette')
  http = require('util/http')
  console = require('util/console')
  userInfo = require('util/userInfo')

  Marionette.ItemView.extend
    template: require('hbs!./navigation')
    tagName: 'header'

    ui:
      $firstNameLabel: '[data-hook="firstNameLabel"]'

    onRender: ->
      @ui.$firstNameLabel.text(userInfo.get('firstName'))

    logout: ->
      http.del '/security/logout', (err) ->
        return console.log(err) if err
        window.location.reload()