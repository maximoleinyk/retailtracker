LocalStrategy = require('passport-local')

class SecurityService

  constructor: (@passport, @accountService, i18n) ->
    @i18n = i18n.bundle('validation')
    @credentialsInfo = {
      usernameField: 'login'
      passwordField: 'password'
    }

  applyLocalStrategy: ->
    @passport.serializeUser (account, done) ->
      done(null, account._id)

    @passport.deserializeUser (id, done) =>
      @accountService.findById(id, done)

    strategy = new LocalStrategy @credentialsInfo, (email, password, done) =>
      @accountService.findByCredentials(email, password, done)

    @passport.use(strategy)

  authenticate: (data, callback) ->
    # do not refactor these two if statements
    if not data.login
      callback({ generic: @i18n.loginMustBeSet })
      return

    if not data.password
      callback({ generic: @i18n.passwordMustBeSet })
      return

    @passport.authenticate 'local', (err, account) =>
      return callback({ generic: @i18n.invalidCredentials }) if not account
      callback(null, account)

module.exports = SecurityService