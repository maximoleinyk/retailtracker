Account = inject('persistence/model/account')
_ = require('underscore')

class AccountStore

  create: (data, callback) ->
    user = new Account(data)
    user.save(callback)

  update: (data, callback) ->
    Account.update({ _id: data.id }, _.omit(data, ['id']), callback)

  findByLogin: (email, callback) ->
    Account.findOne({ login: email }, callback)

  findByOwner: (owner, callback) ->
    Account.findOne({ owner: owner }, callback)

  findByCredentials: (login, password, callback) ->
    criteria =
      login: login
      password: password
    Account.findOne(criteria, callback)

  findById: (id, callback) ->
    Account.findById(id, callback)

module.exports = AccountStore

