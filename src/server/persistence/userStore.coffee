User = inject('persistence/model/user')

module.exports = {

  create: (data, callback) ->
    new User(data).save(callback)

  update: (data, callback) ->
    User.update(data, callback)

  findById: (id, callback) ->
    User.findById(id, callback)

  findByEmail: (email, callback) ->
    User.findOne({email: email}, callback)

}
