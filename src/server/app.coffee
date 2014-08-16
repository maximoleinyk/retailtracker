express = require('express')
bodyParser = require('body-parser')
cookieParser = require('cookie-parser')
passport = require('passport')
rest = inject('rest')
socket = inject('socket')
authentication = inject('authentication')
database = inject('database')

module.exports =

  start: (config) ->
    app = express()
    router = express.Router()

    database.connect app, ->
      app.use '/static', express.static config.app.staticDir
      app.use bodyParser.json()
      app.use passport.initialize()
      app.use passport.session()
      app.use(router)

      authentication(passport)
      rest(router, passport)
      socket(app)

      app.listen config.app.port, ->
        console.log 'Application started on port ' + config.app.port + ' in ' + process.env.NODE_ENV + ' mode'
