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
    bundleName: 'admin'
    beforeStart: (resolve, reject) ->
      fetchUser = new Promise (resolve, reject) =>
        http.get '/user/fetch', (err, result) =>
          if err then reject(err) else resolve(result)

      fetchUser
      .then (userInfo) ->
        UserInfo.set(userInfo)
        resolve()
      .then null, reject
  })
