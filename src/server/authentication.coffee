LocalStrategy = require('passport-local')
userService = inject('services/userService')

module.exports = (passport) ->
  credentialsInfo = {
    usernameField: 'login'
    passwordField: 'password'
  }

  handler = (email, password, done) ->
    userService.findByCredentials(email, password, done)

  passport.serializeUser (user, done) ->
    done(null, user._id)

  passport.deserializeUser (id, done) ->
    userService.findById(id, done)

  passport.use(new LocalStrategy(credentialsInfo, handler))
