module.exports = (app, config) ->

  server = require('http').Server(app)
  io = require('socket.io')(server)
  server.listen(config.socket.port)

  io.on 'connection', (socket) ->
    socket.emit('server', 'Hello from server!')
