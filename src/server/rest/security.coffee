HttpStatus = require('http-status-codes')
eventBus = inject('util/eventBus')
userService = inject('services/userService')
authFilter = inject('util/authFilter')
inviteService = inject('services/inviteService')

module.exports = (router, passport) ->
  router.get '/security/test', authFilter, (req, res) ->
    res.status(HttpStatus.OK).end()

  router.post '/security/register', (req, res) ->
    userService.register req.body, (err) ->
      if err then res.status(HttpStatus.BAD_REQUEST).end() else res.status(200).end()

  router.get '/security/invite/:inviteKey', (req, res) ->
    inviteService.findInvite req.params.inviteKey, (err, invite) ->
      if err or not invite then res.status(HttpStatus.NOT_FOUND).end() else res.send(200, invite)

  router.post '/security/approve', (req, res) ->
    userService.approveRegistration req.body, (err) ->
      if err then res.status(HttpStatus.BAD_REQUEST).end() else res.status(200).end()

  router.post '/security/login', (req, res, next) ->
    passport.authenticate('local', (err, user) ->
      if err
        return next(err)
      else if not user
        return res.status(HttpStatus.FORBIDDEN).end()
      else
        req.login user, (err) ->
          return next(err) if err
          res.status(HttpStatus.OK).send(user)
    )(req, res, next)

  router.delete '/security/logout', authFilter, (req, res) ->
    req.logout()
    res.status(HttpStatus.NO_CONTENT).end()

