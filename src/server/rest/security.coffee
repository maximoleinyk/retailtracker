HttpStatus = require('http-status-codes')
eventBus = inject('util/eventBus')
userService = inject('services/userService')
authFilter = inject('util/authFilter')

module.exports = (router, passport) ->

  router.get '/security/test', authFilter, (req, res) ->
    res.status(HttpStatus.OK).end()

  router.post '/security/register', (req, res) ->
    userService.register(req.body);
    res.status(200).end()

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

  router.delete '/security/logout', authFilter, (req, res) ->
    req.logout()
    res.status(HttpStatus.NO_CONTENT).end()

