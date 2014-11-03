define (require) ->
  'use strict'

  BaseRouter = require('cs!app/common/router')

  BaseRouter.extend

    appRoutes:
      'login': 'login'

      'register': 'registerAccount'
      'register/:inviteKey': 'confirmAccountRegistration'

      'forgot': 'forgotPassword'
      'forgot/:key': 'changeForgottenPassword'