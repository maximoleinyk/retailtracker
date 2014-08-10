userStore = inject('persistence/userStore')

module.exports =

  create: (data, callback) ->
    userStore.create(data, callback)

  findById: (id, callback) ->
    userStore.findById(id, callback)

  findByCredentials: (login, password, callback) ->
    userStore.findByCredentials(login, password, callback)
