LocalStrategy = require('passport-local')
userService = inject('services/userService')

module.exports = (router, passport) ->

  router.post '/security/login', (req, res, next) ->
    authenticate = (err, user) ->
      console.log('LOGIN')
      console.log(user)
      return next(err) if err
      return res.send(401) if not user
      req.logIn user, (err) ->
        return next(err) if err
        res.send(204)
    passport.authenticate('local', authenticate)(req, res, next)

  passport.serializeUser (user, done) ->
    console.log('Serialize')
    console.log(user)
    done(null, user.id)

  passport.deserializeUser (id, done) ->
    console.log('Deserialize')
    userService.findById(id, done)

  passport.use new LocalStrategy {
    emailField: 'username'
    passwordField: 'password'
  }, (username, password, done) ->
    process.nextTick ->
      done(null, {
        id: 1,
        username: username,
        password: password
      })
