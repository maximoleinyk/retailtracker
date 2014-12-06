define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  Navigation = require('cs!./views/navigation')
  Header = require('cs!./views/header')
  http = require('util/http')
  context = require('cs!app/common/context')

  ({
    Router: Router
    Controller: Controller
    Navigation: Navigation
    Header: Header
    bundleName: 'company'
    className: 'company'
    root: '/company/'
    contextUrl: '/context/load/company'

    initialize: (url) ->
      http.setHeaders({ company: url.split('/')[1] })

    beforeStart: (contextData, url) ->
      context.set(context.parse(contextData))
      companyId = url.split('/')[1]

      new Promise (resolve, reject) ->
        http.get '/company/' + companyId + '/permission/' + contextData.owner.id, (err, result) ->
          return reject(err) if err
          return reject('Unknown context') if not result
          context.set('company', result.company)
          # set the company's original namespace
          http.setHeaders({
            account: result.ns
            company: companyId
          })
          resolve()
  })
