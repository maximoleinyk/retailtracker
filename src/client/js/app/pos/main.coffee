define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  context = require('cs!app/common/context')

  ({
    Router: Router
    Controller: Controller
    bundleName: 'pos'
    className: 'point-of-sale'
    root: '/pos/'
    onUserLoaded: (userInfo) ->
      context.set(userInfo)
  })
