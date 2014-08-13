define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  Header = require('cs!./view/header')
  http = require('util/http')
  Promise = require('rsvp').Promise
  UserInfo = require('util/userInfo')

  ({
    Router: Router
    Controller: Controller
    Header: Header

  # Start loading user info before app start
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
