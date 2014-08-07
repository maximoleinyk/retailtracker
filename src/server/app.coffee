express = require('express')
passport = require('passport')
router = inject('router')
socket = inject('socket')
security = inject('security')

app = express()

module.exports = {

  start: (config) ->

    app.configure ->
      app.use '/static', express.static config.staticDir
      app.use express.bodyParser()
      app.use express.methodOverride()
      app.use express.cookieParser config.cookieSecret
      app.use express.session secret: config.sessionSecret
      app.use passport.initialize()
      app.use passport.session()
      app.use app.router

    security(app, passport)
    router(app, config)
    socket(app, config)

    console.log 'Go to http://localhost:' + config.appPort + ' [' + process.env.NODE_ENV + ' mode]'
    app.listen config.appPort

}





