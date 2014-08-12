define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  http = require('util/http')
  UserInfo = require('util/userInfo')
  IO = require('util/io')

  (start) ->
    start({
      Router: Router
      Controller: Controller
      Header: require('cs!./view/header')
      moduleName: 'app/management/main'
      before: ->
        new Promise (resolve, reject) ->
          http.get '/user/fetch', (err, user) ->
            return reject(err) if err

            UserInfo.set(user)
            IO.register "user:#{UserInfo.id}:logout", ->
              window.location.reload()
            resolve()
    })
