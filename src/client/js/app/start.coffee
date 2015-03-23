define [
  'jquery'
  'cs!app/common/moduleLoader'
  'app/common/http'
  'cookies'
], ($, ModuleLoader, http, cookies) ->
  'use strict'

  if document.documentElement.className.indexOf('no-support') > -1
    throw new Error('This application cannot be started in this browser.')

  cookie = document.cookie
  cookieEnabled = navigator.cookieEnabled or ('cookie' in document and (cookie.length > 0 or (cookie = 'test').indexOf.call(cookie,
    'test') > -1))
  document.documentElement.className += if cookieEnabled then ' cookies' else ' no-cookies'

  # set CSRF token from cookies
  http.setHeaders({
    'X-Csrf-Token': cookies.get('X-Csrf-Token')
  })

  # initialize whole module loading mechanism
  loader = new ModuleLoader('/page/', {
    'account': 'account'
    'brand': 'brand'
    'company': 'company'
    'pos': 'pos'
  })
  loader.start('account')
