i18n = inject('i18n').bundle('validation')
Promise = inject('util/promise')
_ = require('underscore')
accountNamespace = inject('util/namespace/account')

class CompanyService

  constructor: (@companyStore, @inviteService, @accountService) ->

  getInvitePromises: (invitees, companyId) ->
    _.map invitees, (employee) =>
      new Promise (resolve, reject) =>
        @inviteService.createCompanyInvite null, companyId, (err, response) =>
          if err then reject(err) else resolve(response)

  findAll: (userId, callback) ->
    findAccount = new Promise (resolve, reject) =>
      @accountService.findByOwner userId, (err, account) ->
        if err then reject(err) else resolve(account)

    findAccount
    .then (account) =>
      Promise.all account.companies.map (meta) =>
        new Promise (resolve, reject) =>
          @companyStore.findById accountNamespace({ session: { ns: meta.ns }}), meta.company, (err, company) ->
            if err then reject(err) else resolve(company)

    .then (companies) =>
      callback(null, companies)

    .catch(callback)

  update: (ns, data, callback) ->
    return callback({ name: i18n.nameRequired }) if not data.name
    return callback({ currencyCode: i18n.currencyCode }) if not data.currencyCode
    return callback({ rate: i18n.currencyRateRequired }) if not data.currencyRate

    loadCompany = new Promise (resolve, reject) =>
      @companyStore.findById ns, data._id, (err, result) =>
        if err then reject(err) else resolve(result)

    loadCompany
    .then (company) =>
      employeesToRemove = []
      _.each company.employees, (originEmployee) =>
        found = _.find data.employees, (latestEmployee) =>
          originEmployee.email is latestEmployee.email
        employeesToRemove.push(originEmployee) if not found
      removeUserAccounts = _.map employeesToRemove, (employeeToRemove) =>
        new Promise (resolve, reject) =>
          @userService.suspendUser employeeToRemove._id, (err, result) =>
            if err then reject(err) else resolve(result)
      Promise.all(removeUserAccounts)

    .then =>
      new Promise (resolve, reject) =>
        @companyStore.update ns, data, (err, result) =>
          if err then reject(err) else resolve(result)

    .then (company) =>
      filteredInvitees = []
      _.each company.invitees, (invitee) ->
        wasFound = false
        _.each company.employees, (employee) ->
          wasFound = true if (employee.email is invitee.email)
        filteredInvitees.push(invitee) if not wasFound
      Promise.all @getInvitePromises(filteredInvitees, company._id)

    .then(callback)
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
          if err then reject(err) else resolve(result.company)

    .then (company) ->
      callback(null, company)

    .catch(callback)

  findById: (ns, companyId, callback) ->
    return callback({ generic: 'Company id is not specified' }) if not companyId
    @companyStore.findById(ns, companyId, callback)

module.exports = CompanyService