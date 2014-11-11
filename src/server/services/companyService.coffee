i18n = inject('i18n').bundle('validation')
Promise = inject('util/promise')
_ = require('underscore')
accountNamespace = inject('util/namespace/account')

class CompanyService

  constructor: (@companyStore, @inviteService, @accountService, @userService, i18n) ->
    @i18n = i18n.bundle('validation')

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
          @companyStore.findById(accountNamespace(meta.ns), meta.company, handler).populate('owner')

    .then (companies) =>
      callback(null, companies)

    .catch(callback)

  getInvitedCompanyDetails: (key, callback) ->
    return callback({ generic: @i18n.inviteNotFound }) if not key

    findInvite = new Promise (resolve, reject) =>
      @inviteService.findByLink key, (err, invite) ->
        if err then reject(err) else resolve(invite)

    findInvite
    .then (invite) =>
      new Promise (resolve, reject) =>
        handler = (err, company) =>
          return reject(err) if err
          return reject({ generic: 'Company does not exist' }) if not company
          resolve(company)

        @findById(accountNamespace(invite.ns), invite.company, handler).populate('owner')

    .then (company) ->
      callback(null, company)

    .catch(callback)

  create: (ns, data, callback) ->
    return callback({ name: i18n.nameRequired }) if not data.name
    return callback({ currencyCode: i18n.currencyCode }) if not data.currencyCode
    return callback({ rate: i18n.currencyRateRequired }) if not data.currencyRate
    return callback({ owner: i18n.ownerIsRequired }) if not data.owner

    createCompany = new Promise (resolve, reject) =>
      @companyStore.create ns, data, (err, result) ->
        if err then reject(err) else resolve(result)

    createCompany
    .then (company) =>
      new Promise (resolve, reject) =>
        @accountService.findByOwner company.owner, (err, account) ->
          if err then reject(err) else resolve({
            account: account
            company: company
          })

    .then (result) =>
      result.account.companies.push({
        ns: result.account._id.toString()
        company: result.company._id
      })
      new Promise (resolve, reject) =>
        @accountService.update result.account.toObject(), (err) ->
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
            namespace = result.account._id.toString()
            @inviteService.createCompanyInvite userId, companyId, namespace, (err) ->
              if err then reject(err) else resolve(companyAndAccount.company)

    .then (company) ->
      callback(null, company)

    .catch(callback)

  findById: (ns, companyId, callback) ->
    @companyStore.findById(ns, companyId, callback).populate('employees')

module.exports = CompanyService