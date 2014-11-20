i18n = inject('i18n').bundle('validation')
Promise = inject('util/promise')
_ = require('underscore')
namespace = inject('util/namespace')

class CompanyMediator

  constructor: (@companyStore, @activityService) ->

  confirmInvitee: (namespaceFromInvite, companyId, user, callback) ->
    findCompany = new Promise (resolve, reject) =>
      @companyStore.findById namespace.accountWrapper(namespaceFromInvite), companyId, (err, company) =>
        if err then reject(err) else resolve(company)

    findCompany
    .then (company) =>
      companyData = company.toJSON()
      companyData.employees.push(user._id)
      companyData.invitees = _.filter companyData.invitees, (invitee) ->
        invitee.email isnt user.email

      new Promise (resolve, reject) =>
        @companyStore.update namespace.accountWrapper(namespaceFromInvite), companyData, (err) =>
          if err then reject(err) else resolve(company)

    .then (company) =>
      @employeeConfirmedInviteToCompany(namespaceFromInvite, user, company)

    .then (company) =>
      callback(null, company)

    .catch(callback)

  employeeConfirmedInviteToCompany: (namespaceFromInvite, user, company) ->
    namespace = namespace.accountWrapper(namespaceFromInvite)
    new Promise (resolve, reject) =>
      @activityService.employeeConfirmedInvitation namespace, user._id, company._id, namespaceFromInvite, (err) ->
        if err then reject(err) else resolve(company)

module.exports = CompanyMediator