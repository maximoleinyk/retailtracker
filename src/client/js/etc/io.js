define(function (require) {
    'use strict';

	var io = require('socket.io'),
		console = require('etc/console'),
		socket = io.connect('http://localhost:4000');

    socket.on('server', function (data) {
        console.log(data);
    });

});
