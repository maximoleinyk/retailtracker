i18n = inject('i18n').bundle('validation')
Promise = inject('util/promise')
_ = require('underscore')
namespace = inject('util/namespace')
mailer = inject('email/mailer')
emailTemplates = inject('email/templates/mapper')
templateCompiler = inject('email/templateCompiler')

class CompanyService

  constructor: (@companyStore, @inviteService, @accountService, @userService, @activityService, @contextService, i18n) ->
    @i18n = i18n.bundle('validation')

  checkPermission: (companyId, userId, callback) ->
    findAccount = new Promise (resolve, reject) =>
      @accountService.findByOwner userId, (err, account) ->
        if err then reject(err) else resolve(account)

    findAccount
    .then (account) =>
      foundCompany = _.find account.toJSON().companies, (pair) =>
        pair.company.toString() is companyId

      if not foundCompany
        return Promise.empty({})
      else
        new Promise (resolve, reject) =>
          @companyStore.findById namespace.accountWrapper(foundCompany.ns), companyId, (err, company) ->
            if err then reject(err) else resolve({
              ns: foundCompany.ns
              company: company
            })

    .then (result) =>
      if not result.company
        return Promise.empty()
      else
        return Promise.empty(result)

    .then (result) ->
      callback(null, result)

    .then(null, callback)

  findAll: (userId, callback) ->
    findAccount = new Promise (resolve, reject) =>
      @accountService.findByOwner userId, (err, account) ->
        if err then reject(err) else resolve(account)

    findAccount
    .then (account) =>
      Promise.all account.companies.map (meta) =>
        new Promise (resolve, reject) =>
          handler = (err, company) ->
            if err then reject(err) else resolve(company)
          @companyStore.findById(namespace.accountWrapper(meta.ns), meta.company, handler).populate('employees owner')

    .then (companies) =>
      callback(null, companies)

    .catch(callback)

  getInvitedCompanyDetails: (key, callback) ->
    return callback({ generic: @i18n.inviteNotFound }) if not key

    findInvite = new Promise (resolve, reject) =>
      @inviteService.findByLink key, (err, invite) ->
        return reject(err) if err
        return reject('Invite not found') if not invite
        resolve(invite)

    findInvite
    .then (invite) =>
      new Promise (resolve, reject) =>
        handler = (err, company) =>
          return reject(err) if err
          return reject({ generic: 'Company does not exist' }) if not company
          resolve(company)

        @findById(namespace.accountWrapper(invite.ns), invite.company, handler).populate('owner')

    .then (company) ->
      callback(null, company)

    .catch(callback)

  create: (ns, data, callback) ->
    return callback({ name: i18n.nameRequired }) if not data.name
    return callback({ currencyCode: i18n.currencyCode }) if not data.currencyCode
    return callback({ rate: i18n.currencyRateRequired }) if not data.currencyRate
    return callback({ owner: i18n.ownerIsRequired }) if not data.owner

    findAccount = new Promise (resolve, reject) =>
      handler = (err, account) =>
        if err then reject(err) else resolve(account)
      @accountService.findByOwner(data.owner, handler).populate('owner')

    findAccount
    .then (account) =>
      data.invitees = _.filter data.invitees, (invitee) ->
        invitee.email isnt account.owner.email
      data.employees.push(account.owner._id)
      createCompany = new Promise (resolve, reject) =>
        @companyStore.create ns, data, (err, company) ->
          if err then reject(err) else resolve({
            account: account
            company: company
          })
      createCompany.then (result) =>
        new Promise (resolve, reject) =>
          @contextService.afterCompanyCreation result.account, result.company, (err) =>
            if err then reject(err) else resolve(result)

    .then (result) =>
      result.account.companies.push({
        ns: result.account._id.toString()
        company: result.company._id
      })
      result.account.owner = result.account.owner._id
      new Promise (resolve, reject) =>
        @accountService.update result.account.toJSON(), (err) ->
          if err then reject(err) else resolve({
            company: result.company
            account: result.account
          })

    .then (companyAndAccount) =>
      Promise.all _.map companyAndAccount.company.invitees, (invite) =>
        findUser = new Promise (resolve, reject) =>
          @userService.findByEmail invite.email, (err, user) =>
            if err then reject(err) else resolve({
              invite: invite
              user: user
              account: companyAndAccount.account
            })

        findUser
        .then (result) =>
          if not result.user
            return new Promise (resolve, reject) =>
              userData = {
                firstName: result.invite.firstName
                email: result.invite.email
              }
              @userService.create userData, (err, user) ->
                if err then reject(err) else resolve({
                  account: result.account
                  user: user
                })
          else
            return Promise.empty({
              account: result.account
              user: result.user
            })

        .then (result) =>
          new Promise (resolve, reject) =>
            userId = result.user._id
            companyId = companyAndAccount.company._id
            accountNamespace = result.account._id.toString()
            @inviteService.createCompanyInvite userId, companyId, accountNamespace, (err, invite) ->
              if err then reject(err) else resolve({
                invite: invite,
                company: companyAndAccount.company
                userId: userId
              })

        .then (result) =>
          @createUserInvitedToCompanyActivityItem(result)

        .then (result) =>
          new Promise (resolve, reject) =>
            mail = emailTemplates(mailer, templateCompiler)
            mail.companyInvite result.invite, (err) ->
              if err then reject(err) else resolve(result.company)

    .then (company) ->
      callback(null, company)

    .catch(callback)

  createUserInvitedToCompanyActivityItem: (result) ->
    accountNamespace = namespace.accountWrapper(result.invite.ns)
    userId = result.userId
    companyId = result.invite.company
    new Promise (resolve, reject) =>
      @activityService.userInvitedIntoCompany accountNamespace, userId, companyId, result.invite.ns, (err) ->
        if err then reject(err) else resolve(result)

  createEmployeeWasRemovedFromCompanyActivityItem: (result) ->
    accountNamespace = namespace.accountWrapper(result.companyOwnerNamespace)
    userId = result.userId
    companyId = result.company
    new Promise (resolve, reject) =>
      @activityService.employeeWasRemovedFromCompany accountNamespace, userId, companyId, result.ns, (err) ->
        if err then reject(err) else resolve(result)

  update: (ns, data, callback) ->
    return callback({ name: i18n.nameRequired }) if not data.name
    return callback({ currencyCode: i18n.currencyCode }) if not data.currencyCode
    return callback({ rate: i18n.currencyRateRequired }) if not data.currencyRate
    return callback({ owner: i18n.ownerIsRequired }) if not data.owner

    findCompany = new Promise (resolve, reject) =>
      handler = (err, company) =>
        return reject(err) if err
        return reject({ generic: @i18n.companyWasNotFound }) if not company
        return reject({ generic: @i18n.currencyRateCannotBeChanged }) if company.currencyRate isnt data.currencyRate
        return reject({ generic: @i18n.currencyCodeCannotBeChanged }) if company.currencyCode isnt data.currencyCode
        resolve(company)
      @companyStore.findById(ns, data.id, handler).populate('employees owner')

    findCompany
    .then (company) =>
      companyData = company.toObject()

      newInvitees = _.filter data.invitees, (newInvitee) ->
        found = _.find company.employees, (employee) ->
          employee.email is newInvitee.email
        return false if found

        found = _.find companyData.invitees, (originInvitee) ->
          originInvitee.email is newInvitee.email
        return not found

      inviteesToRemove = _.filter companyData.invitees, (originInvitee) ->
        found = _.find data.invitees, (newInvitee) ->
          originInvitee.email is newInvitee.email
        return not found

      employeesToRemove = _.filter companyData.employees, (originEmployee) ->
        found = _.find data.employees, (latestEmployee) ->
          originEmployee._id.toString() is latestEmployee.id
        return not found

      removeInvites = Promise.all _.map inviteesToRemove, (inviteeToRemove) =>
        findUser = new Promise (resolve, reject) =>
          @userService.findByEmail inviteeToRemove.email, (err, user) ->
            if err then reject(err) else resolve(user)

        findUser
        .then (user) =>
          new Promise (resolve, reject) =>
            handler = (err, invite) ->
              if err then reject(err) else resolve(invite)
            @inviteService.findByUserAndCompany(user._id, company._id, handler).populate('user')

        .then (invite) =>
          new Promise (resolve, reject) =>
            @inviteService.remove invite, (err) ->
              if err then reject(err) else resolve({
                companyOwnerNamespace: invite.ns
                userId: invite.user._id
                company: invite.company
                ns: invite.ns
              })

        .then (result) =>
          @createEmployeeWasRemovedFromCompanyActivityItem(result)

      removeInvites
      .then =>
        Promise.all _.map employeesToRemove, (employeeToRemove) =>
          findAccount = new Promise (resolve, reject) =>
            @accountService.findByOwner employeeToRemove._id, (err, account) ->
              if err then reject(err) else resolve(account)

          findAccount
          .then (account) =>
            accountData = account.toJSON()
            accountData.companies = _.filter accountData.companies, (pair) ->
              pair.company.toString() isnt company._id.toString()

            new Promise (resolve, reject) =>
              @accountService.update accountData, (err) ->
                # this is the only way to get owner's company namespace
                ownerCompanyNamespace = ns().split('.')[0]
                if err then reject(err) else resolve({
                  companyOwnerNamespace: ownerCompanyNamespace
                  userId: account.owner
                  company: company._id
                  ns: ownerCompanyNamespace
                })

          .then (result) =>
            @createEmployeeWasRemovedFromCompanyActivityItem(result)

      .then =>
        Promise.all _.map newInvitees, (invitee) =>
          findUser = new Promise (resolve, reject) =>
            @userService.findByEmail invitee.email, (err, user) =>
              if err then reject(err) else resolve({
                invitee: invitee
                user: user
              })

          findUser
          .then (result) =>
            if not result.user
              return new Promise (resolve, reject) =>
                userData = {
                  firstName: result.invitee.firstName
                  email: result.invitee.email
                }
                @userService.create userData, (err, user) ->
                  if err then reject(err) else resolve(user)
            else
              return Promise.empty(result.user)

          .then (user) =>
            new Promise (resolve, reject) =>
              @inviteService.createCompanyInvite user._id, company._id, ns('').split('.')[0], (err, invite) ->
                if err then reject(err) else resolve({
                  invite: invite
                  userId: user._id
                })

          .then (result) =>
            new Promise (resolve, reject) =>
              mail = emailTemplates(mailer, templateCompiler)
              mail.companyInvite result.invite, (err) ->
                if err then reject(err) else resolve(result)

          .then (result) =>
            @createUserInvitedToCompanyActivityItem(result)

      .then =>
        new Promise (resolve, reject) =>
          @companyStore.findById ns, data.id, (err) =>
            if (err) then reject(err) else resolve(company)

      .then (latestCompany) =>
        new Promise (resolve, reject) =>
          companyData = latestCompany.toJSON()
          companyData.invitees = _.filter companyData.invitees, (invitee) ->
            found = _.find inviteesToRemove, (removeInvitee) ->
              invitee.email is removeInvitee.email
            return not found
          companyData.invitees = companyData.invitees.concat(newInvitees)

          companyData.employees = _.filter companyData.employees, (originEmployee) ->
            found = _.find employeesToRemove, (removeEmployee) ->
              originEmployee.email is removeEmployee.email
            return not found

          companyData.owner = companyData.owner._id
          companyData.name = data.name
          companyData.description = data.description

          @companyStore.update ns, companyData, (err) =>
            if (err) then reject(err) else resolve(companyData)

    .then (company) ->
      callback(null, company)

    .catch(callback)

  findById: (ns, companyId, callback) ->
    @companyStore.findById(ns, companyId, callback).populate('employees')

module.exports = CompanyService