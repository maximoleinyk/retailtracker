express = require('express')
expressRouter = express.Router()
bodyParser = require('body-parser')
cookieParser = require('cookie-parser')
passport = require('passport')
router = inject('router')
socket = inject('socket')
security = inject('security')
database = inject('database')

module.exports =

  start: (config) ->
    app = express()

    app.use '/static', express.static config.staticDir
    app.use bodyParser.json()

    database.connect app, config, ->
      app.use passport.initialize()
      app.use passport.session()
      app.use expressRouter

      security(expressRouter, passport)
      router(passport, expressRouter, config)
      socket(app, config)

      app.listen config.appPort, ->
        console.log 'Application started on port ' + config.appPort + ' in ' + process.env.NODE_ENV + ' mode'
