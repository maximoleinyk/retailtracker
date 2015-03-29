express = require('express')
bodyParser = require('body-parser')
cookieParser = require('cookie-parser')
passport = require('passport')
controllers = inject('controller')
MongoDB = inject('database')
socket = inject('socket')
csrf = require('csurf')
authenticationFilter = inject('filters/authentication')
errorFilter = inject('filters/error')

class App

  constructor: (@config) ->
    @app = express()
    @store = new MongoDB()

  start: ->
    @store.connect @app, =>

      # middleware
      @app.use '/static', express.static @config.app.staticDir
      @app.use cookieParser(config.cookie.secret, {
        maxAge: config.cookie.maxAge
      })
      @app.use bodyParser.json()
      @app.use passport.initialize()
      @app.use passport.session()
      @app.use csrf()

      # filters
      @app.use authenticationFilter
      @app.use errorFilter

      # controllers
      @app.use controllers(@app, passport)

      @app.listen @config.app.port, =>
        console.log 'Application started on port ' + config.app.port + ' in ' + process.env.NODE_ENV + ' mode'

module.exports = App
