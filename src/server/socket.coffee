eventBus = inject('cs!app/common/eventBus')

module.exports = (app) ->
  server = require('http').Server(app)
  io = require('socket.io')(server)
  server.listen(config.socket.port)
  io.on 'connection', ->
    console.log('Socket connection opened on port ' + config.socket.port)
