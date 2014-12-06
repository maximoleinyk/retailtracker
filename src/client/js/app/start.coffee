define ['cs!./moduleLoader'], (ModuleLoader) ->
  'use strict'

  loader = new ModuleLoader('/page/', {
    'account': 'account'
    'brand': 'brand'
    'company': 'company'
    'pos': 'pos'
  })
  loader.loadModule('account')
