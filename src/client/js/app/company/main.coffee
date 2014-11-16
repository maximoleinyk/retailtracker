define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  Navigation = require('cs!./views/navigation')
  http = require('util/http')
  context = require('cs!app/common/context')

  ({
    Router: Router
    Controller: Controller
    Navigation: Navigation
    bundleName: 'company'
    className: 'company'
    root: '/company/'

    initialize: (path) ->
      http.setHeaders({ company: path.split('/')[1] })

    beforeStart: (userDetails, path) ->
      context.set(userDetails)
      companyId = path.split('/')[1]

      new Promise (resolve, reject) ->
        http.get '/company/' + companyId + '/permission/' + userDetails._id, (err, companyNamespace) ->
          return reject(err) if err
          return reject('Unknown context') if not companyNamespace

          http.setHeaders({ companyNamespace: companyNamespace })
          resolve()
  })
