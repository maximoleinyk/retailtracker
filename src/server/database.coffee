mongoose = require('mongoose')
eventBus = inject('util/eventBus')

module.exports = (config) ->

  mongoose.connection.once 'open', ->
    eventBus.emit('db:open')

  mongoose.connection.on 'error', ->
    eventBus.emit('db:error')

  mongoose.connect(config.dbHost, config.dbName, config.dbPort)
