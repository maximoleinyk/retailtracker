io = require('socket.io')
eventBus = inject('util/eventBus')

module.exports = (app) ->
  server = require('http').Server(app)
  server.listen(config.socket.port)

  io(server).on 'connection', (socket) ->
    console.log('Socket opened on port ' + config.socket.port)
