express = require('express')
router = require('./router')
socket = require('./socket')
app = express()

module.exports = {

  start: (config) ->

    app.configure ->
      app.use '/', express.static config.staticDir
      app.use express.logger()
      app.use express.bodyParser()
      app.use express.methodOverride()
      app.use express.cookieParser config.cookieSecret
      app.use express.session secret: config.sessionSecret
      app.use app.router

    router(app, config)
    socket(app, config)

    console.log 'Go to http://localhost:' + config.appPort + ' [' + process.env.NODE_ENV + ' mode]'
    app.listen config.appPort

}





