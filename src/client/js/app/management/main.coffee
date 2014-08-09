define (require) ->
  'use strict'

  Router = require('cs!app/management/router')
  Controller = require('cs!app/management/controller')
  http = require('util/http')

  (start) ->
    start Router, Controller, {
      Header: require('cs!app/management/view/header')
      before: ->
        new Promise (resolve, reject) ->
          http.get '/user/fetch', (err, user) ->
            if err then reject(err) else ->
              # do something with user
              resolve()
    }
