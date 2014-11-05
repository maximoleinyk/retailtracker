Account = inject('persistence/model/account')

class AccountStore

  create: (data, callback) ->
    user = new Account(data)
    user.save(callback)

  update: (data, callback) ->
    Account.update(data, callback)

  findByLogin: (email, callback) ->
    Account.findOne({ login: email }, callback)

  findByCredentials: (login, password, callback) ->
    criteria =
      login: login
      password: password
    Account.findOne(criteria, callback)

  findById: (id, callback) ->
    Account.findById(id, callback)

module.exports = AccountStore

