define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  Navigation = require('cs!./views/navigation')
  Header = require('cs!./views/header')
  http = require('util/http')
  context = require('cs!app/common/context')
  request = require('util/request')

  ({
    Router: Router
    Controller: Controller
    Navigation: Navigation
    Header: Header
    bundleName: 'company'
    classSelector: 'app-company'
    root: '/company/'
    authUrl: '/context/handshake'

    initialize: (url) ->
      http.setHeaders({ company: url.split('/')[1] })

    beforeStart: (url) ->
      companyId = url.split('/')[1]
      request.get('/context/load/company')

      # load context info
      .then (contextData) ->
        context.set(context.parse(contextData))
        request.get('/company/' + companyId + '/permission/' + contextData.owner.id)

      # check permissions
      .then (result) ->
        return throw 'Unknown context' if not result
        context.set('company', result.company)
        http.setHeaders({
          account: result.ns
          company: companyId
        })
  })
