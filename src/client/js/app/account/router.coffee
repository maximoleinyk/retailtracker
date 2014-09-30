define (require) ->
  'use strict'

  BaseRouter = require('cs!app/common/router')
  BaseRouter.extend
    appRoutes:
      'login': 'login'
      'register': 'registration'
      'register/:inviteKey': 'confirmRegistration'
      'forgot': 'forgotPassword'
      'forgot/:key': 'changeForgottenPassword'

