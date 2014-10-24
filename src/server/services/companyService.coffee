i18n = inject('services/i18nService').bundle('validation')
Promise = inject('util/promise')
_ = require('underscore')

class CompanyService

  constructor: (@linkService, @inviteService, @companyStore) ->

  findAllOwnedByUser: (userId, callback) ->
    @companyStore.findAllOwnedByUser(userId, callback)

  create: (data, callback) ->
    return callback({ name: i18n.nameRequired }) if not data.name
    return callback({ currencyCode: i18n.currencyCode }) if not data.currencyCode
    return callback({ rate: i18n.currencyRateRequired }) if not data.currencyRate

    @companyStore.create data, (err, companyModel) =>
      return callback(err) if err

      promises = _.map data.invitees, (email) =>
        createLink = new Promise (resolve, reject) =>
          @linkService.create email, (err, link) =>
            if err then reject(err) else resolve(link)
        createLink.then (linkModel) =>
          new Promise (resolve, reject) =>
            @inviteService.createCompanyInvite linkModel.email, linkModel.link, companyModel._id, (err, response) =>
              if err then reject(err) else resolve(response)

      Promise.all(promises)
      .then ->
        callback(null, companyModel)
      .catch(callback)

  findById: (companyId, callback) ->
    return callback({ generic: 'Company id is not specified' }) if not companyId
    @companyStore.findById(companyId, callback)

module.exports = CompanyService