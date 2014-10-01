define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  Navigation = require('cs!./views/navigation')
  UserInfo = require('util/userInfo')

  ({
    Router: Router
    Controller: Controller
    Navigation: Navigation
    bundleName: 'organization'
    root: '/organization/'
    onUserLoaded: (userInfo) ->
      UserInfo.set(userInfo)
  })
