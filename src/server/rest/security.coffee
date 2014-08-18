HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
inviteService = inject('services/inviteService')
linkService = inject('services/linkService')

module.exports = (router, passport) ->
  userService = inject('services/userService')(passport)

  router.get '/security/invite/:key', (req, res) ->
    inviteService.find req.params.key, (err, invite) ->
      return res.status(HttpStatus.NOT_FOUND).end() if err or not invite
      res.send(invite)

  router.get '/security/forgot/:key', (req, res) ->
    linkService.findByKey req.params.key, (err, invite) ->
      return res.status(HttpStatus.NOT_FOUND).end() if err or not invite
      res.send(invite)

  router.post '/security/forgot', (req, res) ->
    userService.forgotPassword req.body.email, (err) ->
      return res.status(HttpStatus.BAD_REQUEST).send({ errors: err }) if err
      res.status(HttpStatus.OK).end()

  router.post '/security/password/change', (req, res) ->
    userService.changePassword req.body, (err) ->
      return res.status(HttpStatus.BAD_REQUEST).send({ errors: err }) if err
      res.status(HttpStatus.OK).end()

  router.post '/security/register', (req, res) ->
    userService.register req.body, (err) ->
      return res.status(HttpStatus.BAD_REQUEST).send({ errors: err }) if err
      res.status(HttpStatus.OK).end()

  router.post '/security/approve', (req, res) ->
    userService.approveRegistration req.body, (err) ->
      return res.status(HttpStatus.BAD_REQUEST).send({ errors: err }) if err
      res.status(HttpStatus.OK).end()

  router.post '/security/login', (req, res, next) ->
    loginHandler = (err, user) ->
      return res.status(HttpStatus.BAD_REQUEST).send({ errors: err }) if err
      return res.status(HttpStatus.FORBIDDEN).send({ errors:
        generic: 'Логин или пароль не подходят'}) if not user

      req.login user, (err) ->
        return next(err) if err
        res.status(HttpStatus.OK).send(user)

    userService.authenticate req.body, loginHandler, (callback) ->
      callback(req, res, next)

  router.delete '/security/logout', authFilter, (req, res) ->
    req.logout()
    res.status(HttpStatus.NO_CONTENT).end()

