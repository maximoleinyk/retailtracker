define ['cs!./moduleLoader', 'util/http', 'cookies'], (ModuleLoader, http, cookies) ->
  'use strict'

  http.setHeaders({
    'X-Csrf-Token': cookies.get('X-Csrf-Token')
  })

  loader = new ModuleLoader('/page/', {
    'account': 'account'
    'brand': 'brand'
    'company': 'company'
    'pos': 'pos'
  })
  loader.loadModule('account')