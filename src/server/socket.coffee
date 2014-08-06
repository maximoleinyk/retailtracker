http = require 'http'
socketIo = require 'socket.io'

module.exports = (app, config) ->

	server = http.createServer app
	io = socketIo.listen server

	server.listen config.socketPort

	io.sockets.on 'connection', (socket) ->
		socket.emit('client', { message:'Hello from server!' });
		socket.on 'server', (data) ->
			socket.broadcast.emit 'message', data
