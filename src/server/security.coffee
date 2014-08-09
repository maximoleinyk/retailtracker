LocalStrategy = require('passport-local')
userService = inject('services/userService')

module.exports = (router, passport) ->

  router.get '/user/fetch', (req, res) ->
    if req.isAuthenticated()
      res.status(200).send(req.user)
    else
      res.status(401).send('Unauthorized')

  router.get '/security/test', (req, res) ->
    res.status(if req.isAuthenticated() then 204 else 401).end()

  router.post '/security/login', (req, res, next) ->
    authenticate = (err, user) ->
      return next(err) if err
      return res.status(401).end() if not user
      req.logIn user, (err) ->
        return next(err) if err
        res.status(200).send(user)
    passport.authenticate('local', authenticate)(req, res, next)

  passport.serializeUser (user, done) ->
    done(null, user.id)

  passport.deserializeUser (id, done) ->
    userService.findById(id, done)

  passport.use new LocalStrategy {
    usernameField: 'login'
    passwordField: 'password'
  }, (username, password, done) ->
    process.nextTick ->
      done(null, {
        id: 1,
        username: username,
        password: password
      })
