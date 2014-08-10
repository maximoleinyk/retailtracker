LocalStrategy = require('passport-local')
userService = inject('services/userService')

module.exports = (passport) ->
  credentialsInfo = {
    usernameField: 'login'
    passwordField: 'password'
  }

  handler = (email, password, done) ->
    userService.findByCredentials(email, password, done)

  strategy = new LocalStrategy(credentialsInfo, handler)

  passport.serializeUser (user, done) ->
    done(null, user._id)

  passport.deserializeUser (id, done) ->
    userService.findById(id, done)

  passport.use(strategy)
