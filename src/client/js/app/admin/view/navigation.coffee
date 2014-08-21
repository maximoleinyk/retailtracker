define (require) ->
  'use strict'

  Marionette = require('marionette')
  http = require('util/http')
  console = require('util/console')

  Marionette.ItemView.extend
    template: require('hbs!./navigation')
    tagNme: 'header'

    logout: ->
      http.del '/security/logout', (err) ->
        return console.log(err) if err
        window.location.reload()
