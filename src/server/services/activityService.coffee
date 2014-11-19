Promise = inject('util/promise')
_ = require('underscore')
namespace = inject('util/namespace')

class ActivityService

  constructor: (@activityStore) ->

  fetch: (ns, callback) ->
    fetchActivities = new Promise (resolve, reject) =>
      @activityStore.fetch ns, (err, docs) =>
        if err then reject(err) else resolve(docs)

    fetchActivities
    .then (docs) =>
      companyPromises = []
      _.each docs, (doc) =>
        if doc.company
          companyPromises.push new Promise (resolve, reject) =>
            @companyService.findById namespace.accountWrapper(doc.ns), doc.company, (err, company) ->
              return reject(err) if err
              activityData = doc.toJSON()
              activityData.company = company.toJSON()
              resolve(company)
        else
          companyPromises.push Promise.empty(doc.toJSON())
      Promise.all(companyPromises)

    .then (result) ->
      callback(null, result)

    .catch(callback)

  createActivityItem: (ns, data, callback) ->
    @activityStore.create(ns, data, callback)

  accountRegistrationConfirmed: (ns, userId, callback) ->
    data = {
      dateTime: moment().toDate()
      user: userId
      action: 'ACCOUNT_REGISTRATION_CONFIRMED'
    }
    @createActivityItem(ns, data, callback)

  userConfirmedInvitation: (ns, userId, companyId, companyNamespace, callback) ->
    data = {
      dateTime: moment().toDate()
      user: userId
      action: 'COMPANY_INVITE_CONFIRMED'
      company: companyId,
      ns: companyNamespace
    }
    @createActivityItem(ns, data, callback)

  userInvitedToCompany: (ns, userId, companyId, companyNamespace, callback) ->
    data = {
      dateTime: moment().toDate()
      user: userId
      action: 'USER_INVITED_TO_COMPANY'
      company: companyId,
      ns: companyNamespace
    }
    @createActivityItem(ns, data, callback)

module.exports = ActivityService