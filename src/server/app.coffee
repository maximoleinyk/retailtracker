express = require('express')
bodyParser = require('body-parser')
cookieParser = require('cookie-parser')
passport = require('passport')
HttpStatus = require('http-status-codes')
rest = inject('rest')
socket = inject('socket')
authentication = inject('authentication')
database = inject('database')

module.exports =

  start: (config) ->
    app = express()
    router = express.Router()

    database.connect app, config, ->
      app.use '/static', express.static config.app.staticDir
      app.use bodyParser.json()
      app.use passport.initialize()
      app.use passport.session()
      authentication(passport)
      app.use (req, res, next) ->
        url = req.url
        if url.indexOf('/ui') is 0 or url.indexOf('/static') > -1 or url.indexOf('/security/login') is 0 or url is '/'
          return next()
        if req.isAuthenticated() then next() else res.status(HttpStatus.UNAUTHORIZED).end()
      app.use(router)
      rest(router, passport, config)
      socket(app, config)

      app.listen config.app.port, ->
        console.log 'Application started on port ' + config.app.port + ' in ' + process.env.NODE_ENV + ' mode'
