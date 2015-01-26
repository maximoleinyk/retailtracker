define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  Header = require('cs!./views/header')

  ({
    Router: Router
    Controller: Controller
    Header: Header
    bundleName: 'account'
    classSelector: 'app-account'
    root: '/account/'
    authUrl: '/security/handshake'
  })
