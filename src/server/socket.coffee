
module.exports = (app, config) ->
  server = require('http').Server(app)
  io = require('socket.io')(server);
  server.listen(4000)

  io.on 'connection', (socket) ->
    socket.emit('server', 'Hello from server!');