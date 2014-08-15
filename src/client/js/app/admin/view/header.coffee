define (require) ->
  'use strict'

  Marionette = require('marionette')
  http = require('util/http')
  console = require('util/console')

  Marionette.ItemView.extend
    template: require('hbs!./header')

    events:
      'click [data-id="logout"]': 'logout'

    logout: ->
      http.del '/security/logout', (err) ->
        return console.log(err) if err
        window.location.reload()
