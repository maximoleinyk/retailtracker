module.exports = AccountService

encryptor = inject('util/encryptor')

class AccountService

  constructor: (@accountStore, @inviteService, @userService, @i18nService) ->
    @i18n = i18nService.bundle('validation')

  register: (email, firstName, callback) ->
    return callback({ firstName: @i18n.firstNameRequired }) if not firstName
    return callback({ email: @i18n.emailRequired }) if not email

    findUser = new Promise (resolve, reject) =>
      @userService.findByEmail email, (err, account) ->
        if err then reject(err) else resolve(account)

    findUser
    .then (user) =>
      if not user
        return new Promise (resolve, reject) =>
          userData = {
            firstName: firstName
            email: email
          }
          @userService.create userData, (err, user) ->
            if err then reject(err) else resolve(user)

    .then (user) =>
      new Promise (resolve, reject) =>
        @inviteService.createAccountInvite user, (err, invite) ->
          if err then reject(err) else resolve(invite)

    .then (invite) ->
      callback(null, invite)

    .then null, (err) ->
      callback({ generic: err })

  approve: (email, link, password, callback) ->
    return callback({ email: @i18n.emailRequired }) if not email
    return callback({ link: @i18n.linkRequired }) if not link
    return callback({ password: @i18n.passwordRequired }) if not password

    findInvite = new Promise (resolve, reject) =>
      @inviteService.findByLink link, (err, invite) ->
        return reject(err) if err
        return reject({ generic: 'Invite cannot be found' }) if not invite

        resolve(invite)

    findInvite
    .then (invite) =>
      new Promise (resolve, reject) =>
        accountData = {
          owner: invite.user._id,
          login: email
          password: encryptor.md5(password)
        }
        @accountStore.create accountData, (err, account) ->
          if err then reject(err) else resolve({
            invite: invite
            account: account
          })

    .then (response) =>
      new Promise (resolve, reject) =>
        @inviteService.remove response.invite._id, (err) ->
          if err then reject(err) else resolve(response.account)

    .then (account) ->
      callback(null, account)

    .then(null, callback)

  changePassword: (email, oldPassword, newPassword, callback) ->
    return callback({ email: @i18n.emailRequired }) if not email
    return callback({ oldPassword: @i18n.oldPasswordlRequired }) if not oldPassword
    return callback({ newPassword: @i18n.newPasswordRequired }) if not newPassword
    return callback({ generic: 'Passwords do not match to each other' }) if oldPassword isnt encryptor.encode(newPassword)

    findAccount = new Promise (resolve, reject) =>
      @accountStore.findByOwner email, (err, account) ->
        return reject(err) if err
        return reject({ generic: 'Account cannot be found' }) if not account

        resolve(account)

    findAccount
    .then (account) =>
      accountData = account.toJSON()
      accountData.password = encryptor.encode(newPassword)
      new Promise (resolve, reject) =>
        @accountStore.update accountData, (err, account) ->
          if err then reject(err) else resolve(account)

    .then (account) ->
      callback(null, account)

    .then(null, callback)

  changeForgottenPassword: (email, link, newPassword, callback) ->

