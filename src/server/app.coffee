express = require('express')
bodyParser = require('body-parser')
cookieParser = require('cookie-parser')
passport = require('passport')
PageController = inject('controller')
MongoDB = inject('database')
userService = inject('services/userService')
socket = inject('socket')

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

      controller = new PageController(@router, passport)
      controller.register()

      socket(@app)

      @app.listen @config.app.port, =>
        console.log 'Application started on port ' + config.app.port + ' in ' + process.env.NODE_ENV + ' mode'

module.exports = App
