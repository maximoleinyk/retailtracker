define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  UserInfo = require('util/userInfo')

  ({
    Router: Router
    Controller: Controller
    bundleName: 'pos'
    root: '/pos/'
    onUserLoaded: (userInfo) ->
      UserInfo.set(userInfo)
  })
