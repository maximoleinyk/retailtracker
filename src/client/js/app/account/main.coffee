define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  http = require('util/http')

  ({
    Router: Router
    Controller: Controller
    moduleName: 'account'
    beforeStart: (resolve, reject) ->
      getL10nMessages = new Promise (resolve, reject) ->
        http.get '/i18n/messages/account', (err, response) ->
          if err then reject(err) else resolve(response)

      getL10nMessages
      .then (messages) ->
        window.RetailTracker.i18n = messages;
        resolve()
      .then null, reject
  })
