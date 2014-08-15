define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  Header = require('cs!./view/header')
  http = require('util/http')

  ({
    Router: Router
    Controller: Controller
    Header: Header
    moduleName: 'admin'
  })
