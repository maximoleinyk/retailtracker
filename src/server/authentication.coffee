LocalStrategy = require('passport-local')

class Authentication

  constructor: (@accountService) ->
    @credentialsInfo = {
      usernameField: 'login'
      passwordField: 'password'
    }

  applyLocalStrategy: (passport) ->

    passport.serializeUser (account, done) ->
      done(null, account._id)

    passport.deserializeUser (id, done) =>
      @accountService.findById(id, done)

    strategy = new LocalStrategy @credentialsInfo, (email, password, done) =>
      @accountService.findByCredentials(email, password, done)

    passport.use(strategy)

module.exports = Authentication
