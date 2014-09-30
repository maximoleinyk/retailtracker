express = require('express')
bodyParser = require('body-parser')
cookieParser = require('cookie-parser')
passport = require('passport')
PageController = inject('controller')
Authentication = inject('authentication')
MongoDB = inject('database')
userService = inject('services/userService')

class App

  constructor: (@config) ->
    @app = express()
    @router = express.Router()
    @store = new MongoDB()

  start: ->
    @store.connect @app, =>
      @app.use '/static', express.static @config.app.staticDir
      @app.use bodyParser.json()
      @app.use passport.initialize()
      @app.use passport.session()
      @app.use(@router)

      authenticator = new Authentication(userService, passport)
      authenticator.use(passport)

      controller = new PageController(@router, passport)
      controller.register()

      @app.listen @config.app.port, =>
        console.log 'Application started on port ' + config.app.port + ' in ' + process.env.NODE_ENV + ' mode'

module.exports = App
