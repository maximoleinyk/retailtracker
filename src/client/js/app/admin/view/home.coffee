define (require) ->
  'use strict'

  Marionette = require('marionette')
  http = require('util/http')

  Marionette.ItemView.extend
    template: require('hbs!./home')

    events:
      'click [data-id="sendMail"]': 'sendMail'

    sendMail: ->
      http.get '/sendMail', ->
        console.log('Mail sent.')
