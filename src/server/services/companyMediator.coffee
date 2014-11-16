i18n = inject('i18n').bundle('validation')
Promise = inject('util/promise')
_ = require('underscore')

class CompanyMediator

  constructor: (@companyStore) ->

  confirmInvitee: (ns, companyId, user, callback) ->
    findCompany = new Promise (resolve, reject) =>
      @companyStore.findById ns, companyId, (err, company) =>
        if err then reject(err) else resolve(company)

    findCompany
    .then (company) =>
      companyData = company.toJSON()
      companyData.employees.push(user._id)
      companyData.invitees = _.filter companyData.invitees, (invitee) ->
        invitee.email isnt user.email

      new Promise (resolve, reject) =>
        @companyStore.update ns, companyData, (err) =>
          if err then reject(err) else resolve(company)

    .then (company) =>
      callback(null, company)

    .catch(callback)

module.exports = CompanyMediator