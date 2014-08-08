module.exports = (app, config) ->

  server = require('http').Server(app)
  io = require('socket.io')(server)
  server.listen(config.socketPort)

  io.on 'connection', (socket) ->
    socket.emit('server', 'Hello from server!')
