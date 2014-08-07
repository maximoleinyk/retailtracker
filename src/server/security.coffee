LocalStrategy = require('passport-local')
userService = inject('services/userService')

module.exports = (app, passport) ->

  passport.serializeUser (user, done) ->
    done(null, user.id)

  passport.deserializeUser (id, done) ->
    userService.findById(id, done)

  passport.use new LocalStrategy (login, password, done) ->
    process.nextTick ->
      userService.findById login, (err, user) ->
        return done(err) if err
        return done(null, 401) if not user
        done(null, user)
