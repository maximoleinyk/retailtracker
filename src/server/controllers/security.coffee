HttpStatus = require('http-status-codes')
_ = require('underscore')
authFilter = inject('util/authFilter')

class SecurityController

  constructor: (@securityService) ->

  forbidden: (err, res) ->
    res.status(HttpStatus.FORBIDDEN).send({ errors: err })

  register: (router) ->
    router.post '/security/login', (req, res, next) =>
      authCallback = @securityService.authenticate req.body, (err, account) =>
        return @forbidden(err, res) if err
        req.login account, (err) =>
          return next(err) if err
          res.status(HttpStatus.NO_CONTENT).end()

      authCallback(req, res, next) if authCallback

    router.delete '/security/logout', authFilter, (req, res) ->
      req.logout()
      res.status(HttpStatus.NO_CONTENT).end()

module.exports = SecurityController
