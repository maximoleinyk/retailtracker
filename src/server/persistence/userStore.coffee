User = inject('persistence/model/user')

module.exports =

  create: (data, callback) ->
    user = new User(data)
    user.save(callback)

  findById: (id, callback) ->
    User.findById id, (err, doc) ->
      callback(err, doc?.toObject())

  findByCredentials: (email, password, callback) ->
    criteria =
      email: email
      password: password
    User.findOne criteria, (err, doc) ->
      callback(err, doc?.toObject())
