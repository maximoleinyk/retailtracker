LocalStrategy = require('passport-local')
i18n = inject('util/i18n').bundle('validation')

class SecurityService

  constructor: (@passport, @accountService) ->
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
      @accountService.findByCredentials email, password, (err, account) ->
        return done(err) if err
        return done(i18n.invalidCredentials) if not account
        return done(i18n.accountIsSuspended) if account.status is 'SUSPENDED'
        return done(i18n.accountWasDeleted) if account.status is 'DELETED'
        done(err, account)

    @passport.use(strategy)

  authenticate: (data, callback) ->
    return callback({ generic: i18n.loginMustBeSet }) if not data.login
    return callback({ generic: i18n.passwordMustBeSet }) if not data.password

    @passport.authenticate 'local', (err, account) =>
      if err then callback({ generic: err }) else callback(null, account)

module.exports = SecurityService
