define (require) ->
  'use strict'

  Marionette = require('marionette')
  http = require('util/http')
  console = require('util/console')
  context = require('cs!app/common/context')

  Marionette.ItemView.extend

    template: require('hbs!./navigation')
    tagName: 'header'

    onRender: ->
      @ui.$firstNameLabel.text(context.get('firstName'))

    logout: ->
      http.del '/security/logout', (err) ->
        return console.log(err) if err
        window.location.reload()