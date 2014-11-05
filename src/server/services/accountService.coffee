Encryptor = inject('util/Encryptor')
mailer = inject('email/mailer')
templateCompiler = inject('email/templateCompiler')
Promise = inject('util/promise')
emailTemplates = inject('email/templates/mapper')

class AccountService

  constructor: (@accountStore, @linkService, @inviteService, @userService, @i18nService) ->
    @i18n = i18nService.bundle('validation')

  register: (email, firstName, callback) ->
    return callback({ firstName: @i18n.firstNameRequired }) if not firstName
    return callback({ email: @i18n.emailRequired }) if not email

    findAccount = new Promise (resolve, reject) =>
      @accountStore.findByLogin email, (err, account) =>
        return reject(err) if err
        if account
          switch account.status
            when 'DEPENDANT' then return new Promise (resolve, reject) =>
              account.status = 'OWN'
              account.dependsFrom = null
              @accountStore.update account, (err, account) ->
                if err then reject(err) else resolve(account)
            else
              reject({ generic: @i18n.accountAlreadyExists })
        else
          resolve(account)

    findAccount
    .then =>
      new Promise (resolve, reject) =>
        @userService.findByEmail email, (err, user) ->
          if err then reject(err) else resolve(user)

    .then (user) =>
      if not user
        return new Promise (resolve, reject) =>
          userData = {
            firstName: firstName
            email: email
          }
          @userService.create userData, (err, user) ->
            if err then reject(err) else resolve(user)
      else
        return Promise.empty(user)

    .then (user) =>
      new Promise (resolve, reject) =>
        @inviteService.createAccountInvite user, (err, result) ->
          if err then reject(err) else resolve(result)

    .then (result) ->
      callback(null, result)

    .then(null, callback)

  approve: (link, password, callback) ->
    return callback({ link: @i18n.linkRequired }) if not link
    return callback({ password: @i18n.passwordRequired }) if not password

    findInvite = new Promise (resolve, reject) =>
      @inviteService.findByLink link, (err, invite) ->
        return reject(err) if err
        return reject({ generic: @i18n.inviteCannotBeFound }) if not invite

        resolve(invite)

    findInvite
    .then (invite) =>
      new Promise (resolve, reject) =>
        accountData = {
          owner: invite.user._id,
          login: invite.user.email
          password: Encryptor.md5(password)
        }
        @accountStore.create accountData, (err, account) ->
          if err then reject(err) else resolve({
            invite: invite
            account: account
          })

    .then (response) =>
      new Promise (resolve, reject) =>
        @inviteService.remove response.invite, (err) ->
          if err then reject(err) else resolve(response.account)

    .then (account) ->
      callback(null, account)

    .then(null, callback)

  changePassword: (email, oldPassword, newPassword, callback) ->
    return callback({ email: @i18n.emailRequired }) if not email
    return callback({ oldPassword: @i18n.oldPasswordlRequired }) if not oldPassword
    return callback({ newPassword: @i18n.newPasswordRequired }) if not newPassword
    return callback({ generic: @i18n.passwordsDoNotMatch}) if oldPassword isnt Encryptor.md5(newPassword)

    findAccount = new Promise (resolve, reject) =>
      @accountStore.findByLogin email, (err, account) ->
        return reject(err) if err
        return reject({ generic: @i18n.accountDoesNotExist }) if not account

        resolve(account)

    findAccount
    .then (account) =>
      accountData = account.toJSON()
      accountData.password = Encryptor.md5(newPassword)
      new Promise (resolve, reject) =>
        @accountStore.update accountData, (err, account) ->
          if err then reject(err) else resolve(account)

    .then (account) ->
      callback(null, account)

    .then(null, callback)

  forgotPassword: (email, callback) ->
    return callback({ generic: @i18n.emailRequired }) if not email

    findAccount = new Promise (resolve, reject) =>
      @accountStore.findByLogin email, (err, account) ->
        return reject(err) if err
        return reject(@i18n.accountDoesNotExist) if not account

        resolve(account)

    findAccount
    # TODO: remove previously created links
    .then (account) =>
      new Promise (resolve, reject) =>
        @linkService.create email, (err, link) ->
          if err then reject(err) else resolve({
            link: link
            account: account
          })

    .then (result) ->
      new Promise (resolve, reject) ->
        mail = emailTemplates(mailer, templateCompiler)
        mail.changePassword result.link, (err, mail) ->
          if err then reject(err) else resolve(mail)

    .then (mail) ->
      callback(null, mail)

    .then(null, callback)

  changeForgottenPassword: (key, newPassword, callback) ->
    return callback({ generic: @i18n.linkRequired }) if not key
    return callback({ generic: @i18n.newPasswordRequired }) if not newPassword

    findLink = new Promise (resolve, reject) =>
      @linkService.findByKey key, (err, link) ->
        return reject(err) if err
        return reject({ generic: @i18n.changePasswordRequestCannotBeFound }) if not link

        resolve(link)

    findLink
    .then (link) =>
      new Promise (resolve, reject) =>
        @accountStore.findByLogin link.email, (err, account) ->
          return reject(err) if err
          return reject({ generic: @i18n.accountCouldNotBeFound }) if not account
          resolve({
            link: link
            account: account
          })

    .then (response) =>
      accountData = response.account.toJSON()
      accountData.password = Encryptor.md5(newPassword)
      new Promise (resolve, reject) =>
        @accountStore.update accountData, (err, account) ->
          if err then reject(err) else resolve({
            link: response.link
            account: account
          })

    .then (response) =>
      new Promise (resolve, reject) =>
        @linkService.remove response.link, (err) ->
          if err then reject(err) else resolve(response.account)

    .then (result) ->
      callback(null, result)
    .then(null, callback)

  update: (account, callback) ->
    @accountStore.update(account, callback)

  findById: (id, callback) ->
    @accountStore.findById(id, callback).populate('user')

  findByOwner: (owner, callback) ->
    @accountStore.findByOwner(owner, callback)

  findByCredentials: (login, password, callback) ->
    @accountStore.findByCredentials(login, Encryptor.md5(password), callback).populate('user')

module.exports = AccountService