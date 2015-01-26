mongoose = require('mongoose')
session = require('express-session')
MongoStore = require('connect-mongo')(session)
require('mongoose-multitenant')('.');

class MongoDB

  connect: (app, done) ->
    host = config.db.host
    name = config.db.name
    port = config.db.port

    mongoose.connect host, name, port, (err) ->
      return done(err) if err

      app.use session({
        saveUninitialized: true,
        resave: true
        secret: config.session.secret,
        store: new MongoStore({
          db: mongoose.connection.db
          cookie:
            maxAge: config.cookie.maxAge
        })
        rolling: true
      })

      console.log('Connected to mongo on host ' + config.db.host + ' and port ' + config.db.port)
      done()

module.exports = MongoDB
