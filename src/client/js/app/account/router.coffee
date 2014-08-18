define (require) ->
  'use strict'

  BaseRouter = require('cs!app/common/router')
  BaseRouter.extend
    appRoutes:
      'account/login': 'login'
      'account/register': 'registration'
      'account/approve/:inviteKey': 'registrationConfirm'
      'account/forgot': 'forgotPassword'
      'account/forgot/:key': 'forgotPasswordConfirm'
