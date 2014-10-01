define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  Navigation = require('cs!./view/navigation')
  UserInfo = require('util/userInfo')

  ({
    Router: Router
    Controller: Controller
    Navigation: Navigation
    bundleName: 'admin'
    root: '/admin/'
    onUserLoaded: (userInfo) ->
      UserInfo.set(userInfo)
  })
