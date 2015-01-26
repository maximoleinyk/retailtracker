define (require) ->
  'use strict'

  io = require('socket.io')
  socket = io.connect('http://localhost:4000')
