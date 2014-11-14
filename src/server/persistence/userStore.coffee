User = inject('persistence/model/user')
_ = require('underscore')

class UserStore

  create: (data, callback) ->
    new User(data).save(callback)

  update: (data, callback) ->
    User.update({_id: data._id}, _.omit(data, ['_id']), callback)

  findById: (id, callback) ->
    User.findById(id, callback)

  findByEmail: (email, callback) ->
    User.findOne({email: email}, callback)

module.exports = UserStore