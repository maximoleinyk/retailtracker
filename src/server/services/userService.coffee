class UserService

  constructor: (@userStore) ->

  create: (data, callback) ->
    @userStore.create(data, callback)

  update: (data, callback) ->
    @userStore.update(data, callback)

  findById: (id, callback) ->
    @userStore.findById(id, callback)

  findByEmail: (email, callback) ->
    @userStore.findByEmail(email, callback)

  suspendUser: (user, callback) ->
    # TODO implement

module.exports = UserService