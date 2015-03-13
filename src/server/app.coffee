express = require('express')
bodyParser = require('body-parser')
cookieParser = require('cookie-parser')
passport = require('passport')
PageController = inject('controller')
MongoDB = inject('database')
socket = inject('socket')
csrf = require('csurf')

class App

  constructor: (@config) ->
    @app = express()
    @router = express.Router()
    @store = new MongoDB()

  start: ->
    @store.connect @app, =>
      @app.use '/static', express.static @config.app.staticDir
      @app.use cookieParser(config.cookie.secret, {
        maxAge: config.cookie.maxAge
      })
      @app.use bodyParser.json()
      @app.use passport.initialize()
      @app.use passport.session()
      @app.use csrf()
      @app.use (err, req, res, next) ->
        if err.code is 'EBADCSRFTOKEN'
          return next() if req.url is '/security/login'
          res.status(403).send('CSRF has expired')
        else
          next(err)
      @app.use(@router)

#      socket(@app)

      controller = new PageController(@router, passport)
      controller.register()

      @app.listen @config.app.port, =>
        console.log 'Application started on port ' + config.app.port + ' in ' + process.env.NODE_ENV + ' mode'

module.exports = App
