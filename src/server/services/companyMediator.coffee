i18n = inject('i18n').bundle('validation')
Promise = inject('util/promise')
_ = require('underscore')
accountNamespace = inject('util/namespace/account')

class CompanyMediator

  constructor: (@companyStore) ->

  confirmInvitee: (ns, companyId, user, callback) ->
    findCompany = new Promise (resolve, reject) =>
      @companyStore.findById ns, companyId, (err, company) =>
        if err then reject(err) else resolve(company)

    findCompany
    .then (company) =>
      company.employees.push(user._id)
      resultInvitees = []
      company.invitees.forEach (invitee) =>
        resultInvitees.push(invitee) if invitee.email isnt user.email
      company.invitees.splice(0, company.invitees.length).concat(resultInvitees)

      new Promise (resolve, reject) =>
        @companyStore.update ns, company.toJSON(), (err) =>
          if err then reject(err) else resolve(company)

    .then (company) =>
      callback(null, company)

    .catch(callback)

module.exports = CompanyMediator