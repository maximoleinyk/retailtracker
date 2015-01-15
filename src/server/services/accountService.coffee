Encryptor = inject('util/encryptor')
mailer = inject('email/mailer')
emailTemplates = inject('email/templates/mapper')
templateCompiler = inject('email/templateCompiler')
Promise = inject('util/promise')
namespace = inject('util/namespace')
i18n = inject('util/i18n').bundle('validation')
mail = emailTemplates(mailer, templateCompiler)

class AccountService

  constructor: (@employeeService, @contextService, @companyStore, @accountStore, @linkService, @inviteService, @userService, @activityService) ->

  findById: (id, callback) ->
    @accountStore.findById(id, callback).populate('user')

  findByLogin: (email, callback) ->
    @accountStore.findByLogin(email, callback)

  findByOwner: (owner, callback) ->
    @accountStore.findByOwner(owner, callback)

  findByCredentials: (login, password, callback) ->
    @accountStore.findByCredentials(login, Encryptor.md5(password), callback).populate('user')

  register: (email, firstName, callback) ->
    return callback({ firstName: i18n.firstNameRequired }) if not firstName
    return callback({ email: i18n.emailRequired }) if not email

    findAccount = new Promise (resolve, reject) =>
      @accountStore.findByLogin email, (err, account) =>
        return reject(err) if err
        if account then reject({ generic: i18n.accountAlreadyExists }) else resolve()

    findAccount
    .then =>
      new Promise (resolve, reject) =>
        @inviteService.generateInviteForAccountOwner email, firstName, (err, invite) ->
          if err then reject(err) else resolve(invite)

    .then (invite) =>
      new Promise (resolve, reject) =>
        mail.registrationInvite invite, (err) ->
          if err then reject(err) else resolve()

    .then(callback)
    .catch(callback)

  approveRegistration: (link, password, callback) ->
    return callback({ link: i18n.linkRequired }) if not link
    return callback({ password: i18n.passwordRequired }) if not password

    findInvite = new Promise (resolve, reject) =>
      @inviteService.findByLink link, (err, invite) =>
        return reject(err) if err
        if invite then resolve(invite) else reject({ generic: i18n.inviteCannotBeFound })

    findInvite

    # create unique user
    .then (invite) =>
      userData = {
        firstName: invite.firstName
        email: invite.email
      }
      return new Promise (resolve, reject) =>
        @userService.create userData, (err, user) ->
          if err then reject(err) else resolve({
            user: user
            invite: invite
          })

    # create account
    .then (result) =>
      createNewAccount = new Promise (resolve, reject) =>
        accountData = {
          owner: result.user._id
          login: result.invite.email
          password: Encryptor.md5(password)
        }
        @accountStore.create accountData, (err, account) ->
          if err then reject(err) else resolve({
            invite: result.invite
            account: account
          })

      return createNewAccount.then (result) =>
        return new Promise (resolve, reject) =>
          @contextService.afterAccountCreation result.account, (err) ->
            if err then reject(err) else resolve(result)

    # delete invite link
    .then (result) =>
      new Promise (resolve, reject) =>
        @inviteService.remove result.invite._id, (err) ->
          if err then reject(err) else resolve(result.account)

    # send mail
    .then (account) ->
      new Promise (resolve, reject) ->
        mail.successfulRegistration account, (err) ->
          if err then reject(err) else resolve(account)

    # create activity item
    .then (account) =>
      new Promise (resolve, reject) =>
        @activityService.accountRegistered namespace.accountWrapper(account._id), account.owner, (err) ->
          if err then reject(err) else resolve(account)

    .then (account) ->
      callback(null, account)

    .catch(callback)

  changePassword: (email, oldPassword, newPassword, callback) ->
    return callback({ email: i18n.emailRequired }) if not email
    return callback({ oldPassword: i18n.oldPasswordlRequired }) if not oldPassword
    return callback({ newPassword: i18n.newPasswordRequired }) if not newPassword

    findAccount = new Promise (resolve, reject) =>
      @accountStore.findByLogin email, (err, account) =>
        return reject(err) if err
        return reject({ generic: i18n.accountDoesNotExist }) if not account
        return reject({ generic: i18n.currentPasswordDoesNotMatch }) if account.password isnt Encryptor.md5(oldPassword)
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

    .catch(callback)

  forgotPassword: (email, callback) ->
    return callback({ generic: i18n.emailRequired }) if not email

    findAccount = new Promise (resolve, reject) =>
      @accountStore.findByLogin email, (err, account) =>
        return reject(err) if err
        if not account then reject(i18n.accountDoesNotExist) else resolve(account)

    findAccount
    .then (account) =>
      new Promise (resolve, reject) =>
        @linkService.removeByAccountId account._id, (err) =>
          if err then reject(err) else resolve(account)

    .then (account) =>
      new Promise (resolve, reject) =>
        @linkService.create account._id, (err, link) ->
          if err then reject(err) else resolve({
            link: link
            account: account
          })

    .then (result) ->
      new Promise (resolve, reject) ->
        mail.changePassword result, (err) ->
          if err then reject(err) else resolve()

    .then ->
      callback(null)

    .catch (err) ->
      callback({generic: err})

  changeForgottenPassword: (key, newPassword, callback) ->
    return callback({ generic: i18n.linkRequired }) if not key
    return callback({ generic: i18n.newPasswordRequired }) if not newPassword

    findLink = new Promise (resolve, reject) =>
      @linkService.findByKey key, (err, link) =>
        return reject(err) if err
        if not link then reject({ generic: i18n.changePasswordRequestCannotBeFound }) else resolve(link)

    findLink
    .then (link) =>
      new Promise (resolve, reject) =>
        @accountStore.findById link.account, (err, account) =>
          return reject(err) if err
          if not account then reject({ generic: i18n.accountCouldNotBeFound }) else resolve({
            link: link
            account: account
          })

    .then (response) =>
      accountData = response.account.toJSON()
      accountData.password = Encryptor.md5(newPassword)
      new Promise (resolve, reject) =>
        @accountStore.update accountData, (err) ->
          if err then reject(err) else resolve(response.link)

    .then (link) =>
      new Promise (resolve, reject) =>
        @linkService.removeByKey link.link, (err, result) ->
          if err then reject(err) else resolve(result)

    .then (result) ->
      callback(null, result)

    .catch(callback)

  confirmCompanyInvite: (link, password, callback) ->
    return callback({ key: i18n.linkRequired }) if not link

    findInvite = new Promise (resolve, reject) =>
      @inviteService.findByLink link, (err, invite) =>
        return reject(err) if err
        if not invite then reject({ generic: i18n.inviteNotFound }) else resolve(invite)

    findInvite

    # find user
    .then (invite) =>
      new Promise (resolve, reject) =>
        @userService.findByEmail invite.email, (err, user) =>
          if err then reject(err) else resolve({
            user: user
            invite: invite
          })

    # create user if not exists
    .then (result) =>
      return Promise.empty(result) if result.user

      userData = {
        firstName: result.invite.firstName
        email: result.invite.email
      }
      new Promise (resolve, reject) =>
        @userService.create userData, (err, user) ->
          return reject(err) if err
          return reject({ password: i18n.passwordRequired }) if not user and not password
          resolve({
            user: user
            invite: result.invite
          })

    # find account
    .then (result) =>
      new Promise (resolve, reject) =>
        @accountStore.findByLogin result.invite.email, (err, account) =>
          return reject(err) if err
          return reject({ password: i18n.passwordRequired }) if not account and not password
          resolve({
            user: result.user
            invite: result.invite
            account: account
          })

    # create account if not exists
    .then (result) =>
      if result.account
        return Promise.empty(result)
      else
        accountData = {
          owner: result.user._id,
          login: result.user.email
          password: Encryptor.md5(password)
          dependsFrom: result.invite.account
        }
        createNewAccount = new Promise (resolve, reject) =>
          @accountStore.create accountData, (err, account) ->
            if err then reject(err) else resolve({
              account: account
              invite: result.invite
              user: result.user
            })

        createNewAccount.then (result) =>
          return new Promise (resolve, reject) =>
            @contextService.afterAccountCreation result.account, (err) ->
              if err then reject(err) else resolve(result)

    # add company to invitee's account
    .then (result) =>
      data = result.account.toJSON()
      data.companies.push({
        account: result.invite.account # someones' account
        company: result.invite.company
      })
      new Promise (resolve, reject) =>
        @accountStore.update data, (err) =>
          if err then reject(err) else resolve(result)

    .then (result) =>
      originCompanyNamespace = namespace.companyWrapper(result.invite.account, result.invite.company)
      originCompanyInviteNs = namespace.accountWrapper(result.invite.account)

      data = {
        firstName: result.user.firstName
        lastName: result.user.lastName
        role: result.invite.role
        email: result.invite.email
      }
      createEmployee = new Promise (resolve, reject) =>
        @employeeService.create originCompanyNamespace, data, (err, employee) =>
          if err then reject(err) else resolve(employee)

      createEmployee
      .then (employee) =>
        new Promise (resolve, reject) =>
          @companyStore.findById originCompanyInviteNs, result.invite.company, (err, company) =>
            if err then reject(err) else resolve({
              company: company
              employee: employee
            })

      # update origin company employees list
      .then (employeeAndCompany) =>
        company = employeeAndCompany.company
        company.employees.push(employeeAndCompany.employee._id)
        company.invitees = company.invitees.filter (invitee) ->
          invitee.email isnt result.invite.email

        new Promise (resolve, reject) =>
          @companyStore.update originCompanyInviteNs, employeeAndCompany.company.toJSON(), (err) =>
            if err then reject(err) else resolve(employeeAndCompany)

      # create activity item inside of company owner's account
      .then (employeeAndCompany) =>
        employeeId = result.user._id
        companyId = employeeAndCompany.company._id
        new Promise (resolve, reject) =>
          @activityService.employeeConfirmedInvitation originCompanyInviteNs, employeeId, companyId, originCompanyInviteNs().split('.')[0], (err) ->
            if err then reject(err) else resolve(result)

    # create activity item inside of employee's account
    .then (result) =>
      accountNamespace = namespace.accountWrapper(result.account._id)
      userId = result.user._id
      companyId = result.invite.company
      new Promise (resolve, reject) =>
        @activityService.employeeConfirmedInvitation accountNamespace, userId, companyId, result.invite.account, (err) ->
          if err then reject(err) else resolve(result)

    .then (result) =>
      new Promise (resolve, reject) =>
        @inviteService.remove result.invite._id, (err) ->
          if err then reject(err) else resolve(result.account)

    .then (result) ->
      callback(null, result)

    .catch(callback)

  update: (account, callback) ->
    @accountStore.update(account, callback)

module.exports = AccountService
