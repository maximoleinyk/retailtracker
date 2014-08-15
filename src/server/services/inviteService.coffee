inviteStore = inject('persistence/inviteStore')
eventBus = inject('util/eventBus')

module.exports =

  find: (key, callback) ->
    inviteStore.findByKey(key, callback)

  create: (data, callback) ->
    inviteStore.create(data, callback)