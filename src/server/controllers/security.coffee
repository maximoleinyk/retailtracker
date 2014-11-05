HttpStatus = require('http-status-codes')
_ = require('underscore')
authFilter = inject('util/authFilter')

class SecurityController

  error: (err, res) ->
    res.status(HttpStatus.BAD_REQUEST).send({errors: err})

  register: (router, passport) ->
    router.post '/security/login', (req, res, next) =>
      return @error('Invalid login/password', res) if not req.body.login or not req.body.password

      loginHandler = (err, account) ->
        return res.status(HttpStatus.FORBIDDEN).send({
          errors:
            generic: 'Учетной записи не существует'
        }) if not account

        req.login account, (err) ->
          return next(err) if err
          res.status(HttpStatus.NO_CONTENT).end()

      passport.authenticate('local', loginHandler)(req, res, next)

    router.delete '/security/logout', authFilter, (req, res) ->
      req.logout()
      res.status(HttpStatus.NO_CONTENT).end()

module.exports = SecurityController
