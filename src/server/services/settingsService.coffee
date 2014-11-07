_ = require('underscore')
Promise = inject('util/promise')

class SettingsService

  constructor: (i18n, @userService, @accountService) ->
    @i18n = i18n.bundle('validation')

  changePassword: (userId, oldPassword, newPassword, callback) ->
    return callback({ generic: 'User id should be specified' }) if not userId
    return callback({ oldPassword: @i18n.oldPasswordRequired }) if not oldPassword
    return callback({ password: @i18n.newPasswordRequired }) if not newPassword

    findAccount = new Promise (resolve, reject) =>
      handler = (err, account) =>
        return reject(err) if err
        return reject({ generic: @i18n.accountCouldNotBeFound }) if not account
        resolve(account)
      @accountService.findByOwner(userId, handler).populate('owner')

    findAccount
    .then (account) =>
      new Promise (resolve, reject) =>
        @accountService.changePassword account.owner.email, oldPassword, newPassword, (err, account) ->
          if err then reject(err) else resolve(account.owner)

    .then (user) ->
      callback(null, user)

    .catch(callback)

  changeProfile: (data, callback) ->
    return callback({ generic: 'User id should be specified' }) if not data.id
    return callback({ firstName: @i18n.firstNameRequired }) if not data.firstName

    findUser = new Promise (resolve, reject) =>
      @userService.findById data.id, (err, user) =>
        return reject(err) if err
        return reject({ generic: @i18n.userNotFound }) if not user
        resolve(user)

    findUser
    .then (user) =>
      userData = user.toJSON()
      userData.firstName = data.firstName
      userData.lastName = data.lastName
      new Promise (resolve, reject) =>
        @userService.update userData, (err, user) ->
          if err then reject(err) else resolve(user)

    .then (user) ->
      callback(null, user)

    .catch(callback)

module.exports = SettingsService