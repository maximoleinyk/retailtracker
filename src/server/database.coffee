mongoose = require('mongoose')
session = require('express-session')
MongoStore = require('connect-mongo')(session)

module.exports =

  connect: (app, config, done) ->

    host = config.db.host
    name = config.db.name
    port = config.db.port

    mongoose.connect host, name, port, (err) ->
      return done(err) if err

      app.use session({
        saveUninitialized: true,
        resave: true
        secret: config.app.sessionSecret,
        store: new MongoStore({
          db: mongoose.connection.db
          cookie:
            maxAge: 1000 * 60 * 60 # one hour
        })
      })

      console.log('Connected to mongo on host ' + config.db.host + ' and port ' + config.db.port)
      done()
