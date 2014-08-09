mongoose = require('mongoose')
session = require('express-session')
MongoStore = require('connect-mongo')(session)

module.exports =

  connect: (app, config, done) ->
    mongoose.connect config.dbHost, config.dbName, config.dbPort, (err) ->
      throw err if err
      console.log('Connected to mongo on: ' + config.dbHost + ':' + config.dbPort)
      app.use session({
        saveUninitialized: true,
        resave: true
        secret: config.sessionSecret,
        store: new MongoStore({
          db: mongoose.connection.db
          cookie:
            maxAge: 1000 * 60 * 60 * 2
        })
      })
      # release the chain
      done()
