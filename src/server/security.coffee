LocalStrategy = require('passport-local')
userService = inject('services/userService')

module.exports = (passport) ->

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
