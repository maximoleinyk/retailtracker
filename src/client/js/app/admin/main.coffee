define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  Header = require('cs!./view/header')
  http = require('util/http')
  UserInfo = require('util/userInfo')

  ({
    Router: Router
    Controller: Controller
    Header: Header
    moduleName: 'admin'
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
