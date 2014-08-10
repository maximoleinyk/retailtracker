define(function (require) {
    'use strict';

	var io = require('socket.io'),
		socket = io.connect('http://localhost:4000');

	return {
		register: function(eventName, callback) {
			return socket.on(eventName, callback);
		}
	}

});
