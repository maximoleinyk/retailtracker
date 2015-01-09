define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  Header = require('cs!./views/header')
  http = require('app/common/http')
  context = require('cs!app/common/context')
  request = require('app/common/request')

  ({
    Router: Router
    Controller: Controller
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
