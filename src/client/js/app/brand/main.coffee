define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  Navigation = require('cs!./views/navigation')
  context = require('cs!app/common/context')

  ({
    Router: Router
    Controller: Controller
    Navigation: Navigation
    bundleName: 'brand'
    className: 'brand'
    root: '/brand/'
    onUserLoaded: (userInfo) ->
      context.set(userInfo)
  })
