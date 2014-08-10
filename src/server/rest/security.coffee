HttpStatus = require('http-status-codes')

module.exports = (router, passport) ->

  router.get '/security/test', (req, res) ->
    res.status(if req.isAuthenticated() then HttpStatus.OK else HttpStatus.UNAUTHORIZED).end()

  router.delete '/security/logout', (req, res) ->
    if !req.isAuthenticated()
      return res.status(HttpStatus.NOT_ACCEPTABLE).end()
    req.logout()
    res.status(HttpStatus.NO_CONTENT).end()

  router.post '/security/login', (req, res, next) ->
    passport.authenticate('local', (err, user) ->
      if err
        return next(err)
      else if not user
        return res.status(HttpStatus.FORBIDDEN).end()
      else
        req.login user, (err) ->
          if err
            return next(err)
          res.status(HttpStatus.OK).send(user)
    )(req, res, next)
