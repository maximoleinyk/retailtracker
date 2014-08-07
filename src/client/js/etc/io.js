define(['socket.io'], function (io) {
    'use strict';

    var socket = io.connect('http://localhost:4000');
    socket.on('server', function (data) {
        console.log(data);
    });

});
