express = require('express')
session = require('express-session')
expressRouter = express.Router()
bodyParser = require('body-parser')
cookieParser = require('cookie-parser')
passport = require('passport')
MongoStore = require('connect-mongo')(session)
router = inject('router')
socket = inject('socket')
security = inject('security')

module.exports =

  start: (config) ->

    app = express()
    app.use '/static', express.static config.staticDir
    app.use bodyParser.json()
    app.use bodyParser.json({ type: 'application/vnd.api+json' })
    app.use bodyParser.urlencoded({ extended: false })
    app.use cookieParser(config.cookieSecret)
    app.use session({
      saveUninitialized: true,
      resave: true
      cookie:
        maxAge: 1000 * 60 * 60
        secure: true
      secret: config.sessionSecret,
      store: new MongoStore({
        db: config.dbName
        host: config.dbHost
        port: config.dbPort
      })
    })
    app.use passport.initialize()
    app.use passport.session()
    app.use expressRouter

    security(expressRouter, passport)
    router(passport, expressRouter, config)
    socket(app, config)

    app.listen config.appPort, ->
      console.log 'Application started on port ' + config.appPort + ' in ' + process.env.NODE_ENV + ' mode'
