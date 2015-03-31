HttpStatus = require('http-status-codes')

class SecurityController

  constructor: (@securityService) ->

  forbidden: (err, res) ->
    res.status(HttpStatus.FORBIDDEN).send({ errors: err })

  register: (router) ->
    router.get '/security/handshake', (req, res) =>
      res.cookie('X-Csrf-Token', req.csrfToken())
      res.status(HttpStatus.NO_CONTENT).end()

    router.post '/security/login', (req, res, next) =>
      authCallback = @securityService.authenticate req.body, (err, account) =>
        return @forbidden(err, res) if err
        req.login account, (err) =>
          return next(err) if err
          res.cookie('X-Csrf-Token', req.csrfToken())
          res.status(HttpStatus.NO_CONTENT).end()

      authCallback(req, res, next) if authCallback

    router.delete '/security/logout', (req, res) ->
      req.logout()
      res.status(HttpStatus.NO_CONTENT).end()

module.exports = SecurityController
