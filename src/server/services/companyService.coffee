i18n = inject('util/i18n').bundle('validation')
Promise = inject('util/promise')
_ = require('underscore')
namespace = inject('util/namespace')
mailer = inject('email/mailer')
emailTemplates = inject('email/templates/mapper')
templateCompiler = inject('email/templateCompiler')
mail = emailTemplates(mailer, templateCompiler)

class CompanyService

  constructor: (@employeeService, @roleService, @companyStore, @inviteService, @accountService, @userService, @activityService, @contextService) ->

  findById: (ns, companyId, callback) ->
    @companyStore.findById(ns, companyId, callback)

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
          @companyStore.findById(namespace.accountWrapper(meta.account), meta.company, handler).populate('owner')

    .then (companies) =>
      callback(null, companies)

    .catch(callback)

  getInvitedCompanyDetails: (key, callback) ->
    return callback({ generic: i18n.inviteNotFound }) if not key

    findInvite = new Promise (resolve, reject) =>
      @inviteService.findByLink key, (err, invite) ->
        return reject(err) if err
        return reject({ generic: i18n.inviteNotFound }) if not invite
        resolve(invite)

    findInvite
    .then (invite) =>
      new Promise (resolve, reject) =>
        handler = (err, company) =>
          return reject(err) if err
          return reject({ generic: 'Company does not exist' }) if not company
          resolve({
            company: company
            invite: invite
          })

        @findById(namespace.accountWrapper(invite.account), invite.company, handler).populate('owner')

    .then (result) =>
      new Promise (resolve, reject) =>
        @accountService.findByLogin result.invite.email, (err, account) ->
          if err then reject(err) else resolve({
            company: result.company
            hasAccount: !!account
          })

    .then (result) ->
      callback(null, result)

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
      createCompany = new Promise (resolve, reject) =>
        @companyStore.create ns, data, (err, company) ->
          if err then reject(err) else resolve({
            account: account
            company: company
          })
      createCompany
      .then (result) =>
        new Promise (resolve, reject) =>
          @contextService.afterCompanyCreation result.account, result.company, (err) =>
            if err then reject(err) else resolve(result)
      .then (result) =>
        new Promise (resolve, reject) =>
          @roleService.findByName namespace.accountWrapper(result.account._id), 'BOSS', (err, role) ->
            if err then reject(err) else resolve({
              account: result.account
              company: result.company
              role: role
            })
      .then (result) =>
        companyNamespace = namespace.companyWrapper(result.account._id, result.company._id)
        new Promise (resolve, reject) =>
          employeeData = {
            firstName: result.account.owner.firstName
            lastName: result.account.owner.lastName
            email: result.account.owner.email
            role: result.role._id
          }
          @employeeService.create companyNamespace, employeeData, (err, employee) ->
            if err then reject(err) else resolve(_.extend(result, {employee: employee}))
      .then (result) =>
        new Promise (resolve, reject) =>
          result.company.employees.push(result.employee._id)
          @companyStore.update namespace.accountWrapper(result.account._id), result.company.toJSON(), (err) ->
            if err then reject(err) else resolve({
              account: account
              company: result.company
            })

    .then (result) =>
      result.account.companies.push({
        account: result.account._id
        company: result.company._id
      })
      # do not remove object should be an ObjectId
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
          inviteData = {
            firstName: result.user.firstName
            email: result.user.email
            role: invite.role
            account: companyAndAccount.account._id
            company: companyAndAccount.company._id
          }
          new Promise (resolve, reject) =>
            @inviteService.generateInviteForEmployee inviteData, (err, invite) ->
              if err then reject(err) else resolve({
                invite: invite,
                company: companyAndAccount.company
                userId: result.user._id
              })

        .then (result) =>
          @createUserInvitedToCompanyActivityItem(result)

    .then (company) ->
      callback(null, company)

    .catch(callback)

  update: (ns, data, callback) ->
    return callback({ name: i18n.nameRequired }) if not data.name
    return callback({ currencyCode: i18n.currencyCode }) if not data.currencyCode
    return callback({ rate: i18n.currencyRateRequired }) if not data.currencyRate
    return callback({ owner: i18n.ownerIsRequired }) if not data.owner

    findCompany = new Promise (resolve, reject) =>
      handler = (err, company) =>
        return reject(err) if err
        return reject({ generic: i18n.companyWasNotFound }) if not company
        return reject({ generic: i18n.currencyRateCannotBeChanged }) if company.currencyRate isnt data.currencyRate
        return reject({ generic: i18n.currencyCodeCannotBeChanged }) if company.currencyCode isnt data.currencyCode
        resolve(company)
      @companyStore.findById(ns, data.id, handler).populate('owner')

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
          originEmployee._id.toString() is latestEmployee._id
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
              @inviteService.generateInviteForEmployee user._id, company._id, ns('').split('.')[0], (err, invite) ->
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

  createUserInvitedToCompanyActivityItem: (result) ->
    accountNamespace = namespace.accountWrapper(result.invite.account)
    userId = result.userId
    companyId = result.invite.company
    new Promise (resolve, reject) =>
      @activityService.userInvitedIntoCompany accountNamespace, userId, companyId, result.invite.account, (err) ->
        if err then reject(err) else resolve(result)

  createEmployeeWasRemovedFromCompanyActivityItem: (result) ->
    accountNamespace = namespace.accountWrapper(result.companyOwnerNamespace)
    userId = result.userId
    companyId = result.company
    new Promise (resolve, reject) =>
      @activityService.employeeWasRemovedFromCompany accountNamespace, userId, companyId, result.ns, (err) ->
        if err then reject(err) else resolve(result)

module.exports = CompanyService
