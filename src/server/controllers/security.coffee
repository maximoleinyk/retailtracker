HttpStatus = require('http-status-codes')
_ = require('underscore')
authFilter = inject('util/authFilter')

class SecurityController

  register: (router, passport) ->

    router.post '/security/login', (req, res, next) ->
      errors = {}
      errors.login = '' if not req.body.login
      errors.password = '' if not req.body.password
      return res.status(HttpStatus.BAD_REQUEST).send({errors: errors}) if not _.isEmpty(errors)

      loginHandler = (err, user) ->
        return res.status(HttpStatus.FORBIDDEN).send({
          errors:
            generic: 'Логин или пароль не совпадают'
        }) if not user

        req.login user, (err) ->
          return next(err) if err
          res.status(HttpStatus.OK).send(user)

      passport.authenticate('local', loginHandler)(req, res, next)

    router.delete '/security/logout', authFilter, (req, res) ->
      req.logout()
      res.status(HttpStatus.NO_CONTENT).end()

module.exports = SecurityController
