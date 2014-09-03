define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  Navigation = require('cs!./view/navigation')
  http = require('util/http')
  UserInfo = require('util/userInfo')

  ({
    Router: Router
    Controller: Controller
    Navigation: Navigation
    moduleName: 'admin'
    beforeStart: (resolve, reject) ->
      fetchUser = new Promise (resolve, reject) =>
        http.get '/user/fetch', (err, result) =>
          if err then reject(err) else resolve(result)

      fetchUser
      .then (userInfo) ->
        UserInfo.set(userInfo)
        new Promise (resolve, reject) ->
          http.get '/i18n/messages/admin', (err, response) ->
            if err then reject(err) else resolve(response)
      .then (messages) ->
        window.RetailTracker.i18n = messages;
        resolve()
      .then null, reject
  })
