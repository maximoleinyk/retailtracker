eventBus = inject('util/eventBus')

module.exports = (app) ->
  server = require('http').Server(app)
  io = require('socket.io')(server)
  server.listen(config.socket.port)
#  io.on 'connection', (socket) ->
