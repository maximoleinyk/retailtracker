define (require) ->
  'use strict'

  BaseRouter = require('cs!app/common/router')
  BaseRouter.extend
    silentRoutes:
      'register/success': 'success'

    appRoutes:
      'account/login': 'login'
      'account/register': 'register'
      'account/approve/:inviteKey': 'approve'
      'account/forgot': 'forgot'
