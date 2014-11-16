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

    beforeStart: (accountDetails, path) ->
      context.set(accountDetails)
      companyId = path.split('/')[1]

      new Promise (resolve, reject) ->
        http.get '/company/' + companyId + '/permission/' + accountDetails.owner._id, (err, result) ->
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
