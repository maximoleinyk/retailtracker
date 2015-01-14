Account = inject('persistence/model/account')
_ = require('underscore')

class AccountStore

  create: (data, callback) ->
    user = new Account(data)
    user.save(callback)

  update: (data, callback) ->
    Account.update({ _id: data._id or data.id }, _.omit(data, ['_id']), callback)

  findByLogin: (login, callback) ->
    Account.findOne({ login: login }, callback)

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

