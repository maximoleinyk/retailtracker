i18n = inject('services/i18nService').bundle('validation')
Promise = inject('util/promise')
_ = require('underscore')

class CompanyService

  constructor: (@inviteService, @companyStore) ->

  getInvitePromises: (invitees, companyId) ->
    _.map invitees, (employee) =>
      new Promise (resolve, reject) =>
        @inviteService.createCompanyInvite null, companyId, (err, response) =>
          if err then reject(err) else resolve(response)

  findAllOwnedByUser: (ns, userId, callback) ->
    @companyStore.findAllOwnedByUser(ns, userId, callback)

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

    createCompany = new Promise (resolve, reject) =>
      @companyStore.create ns, data, (err, result) ->
        if err then reject(err) else resolve(result)

    createCompany.then (company) =>
      Promise.all @getInvitePromises(data.invitees, company._id)

    .then(callback)
    .catch(callback)

  findById: (ns, companyId, callback) ->
    return callback({ generic: 'Company id is not specified' }) if not companyId
    @companyStore.findById(ns, companyId, callback)

module.exports = CompanyService