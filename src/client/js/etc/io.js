define(['socket.io'], function(io) {
	'use strict';

	var socket = io.connect('http://localhost:8081');

		socket.on('connect', function () {
			socket.on('client', function() {
				socket.emit('server', {mesage: 'Hello from client!'});
			});
		});

});
