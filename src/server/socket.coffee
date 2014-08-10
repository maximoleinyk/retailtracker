eventBus = inject('util/eventBus')

module.exports = (app, config, callback) ->
  server = require('http').Server(app)
  io = require('socket.io')(server)
  server.listen(config.socket.port)
  io.on 'connection', (socket) ->
    console.log('Socket connection opened on port ' + config.socket.port)
    callback(socket)
