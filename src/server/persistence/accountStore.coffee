Account = inject('persistence/model/account')

class AccountStore

  create: (data, callback) ->
    user = new Account(data)
    user.save(callback)

  update: (data, callback) ->
    Account.update(data, callback)

  findByLogin: (email, callback) ->
    Account.findOne({ login: email }, callback)

module.exports = AccountStore

