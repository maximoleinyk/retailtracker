LocalStrategy = require('passport-local')

class Authentication

  constructor: (@userService) ->
    @credentialsInfo = {
      usernameField: 'login'
      passwordField: 'password'
    }

  use: (passport) ->

    passport.serializeUser (user, done) ->
      done(null, user._id)

    passport.deserializeUser (id, done) =>
      @userService.findById(id, done)

    strategy = new LocalStrategy @credentialsInfo, (email, password, done) =>
      @userService.findByCredentials(email, password, done)

    passport.use(strategy)

module.exports = Authentication
