define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  http = require('util/http')
  UserInfo = require('util/userInfo')
  IO = require('util/io')

  (start) ->
    start(Router, Controller, {
      Header: require('cs!./view/header')
      before: ->
        new Promise (resolve, reject) ->
          http.get '/user/fetch', (err, user) ->
            if err then reject(err) else ->
              UserInfo.set(user);
              IO.register "user:#{UserInfo.id}:logout", ->
                window.location.reload()
              resolve()
    })
