Promise = inject('util/promise')
_ = require('underscore')
namespace = inject('util/namespace')
moment = require('moment')

class ActivityService

  constructor: (@activityStore, @companyStore) ->

  findCompany: (activityItem) ->
    findCompany = new Promise (resolve, reject) =>
      @companyStore.findById namespace.accountWrapper(activityItem.ns), activityItem.company, (err, company) ->
        if err then reject(err) else resolve(company)

    findCompany
    .then (company) ->
      activityData = activityItem.toJSON()
      activityData.company = company.toJSON()
      Promise.empty(activityData)

  fetch: (ns, callback) ->
    fetchActivities = new Promise (resolve, reject) =>
      @activityStore.fetch ns, (err, docs) =>
        if err then reject(err) else resolve(docs)

    fetchActivities
    .then (docs) =>
      companyPromises = []
      _.each docs, (activityItem) =>
        if activityItem.company
          companyPromises.push @findCompany(activityItem)
        else
          companyPromises.push Promise.empty(activityItem.toJSON())
      Promise.all(companyPromises)

    .then (result) ->
      callback(null, result)

    .catch(callback)

  createActivityItem: (ns, data, callback) ->
    @activityStore.create(ns, data, callback)

  accountRegistered: (ns, userId, callback) ->
    data = {
      dateTime: moment().toDate()
      user: userId
      action: 'ACCOUNT_REGISTERED'
    }
    @createActivityItem(ns, data, callback)

  userInvitedIntoCompany: (ns, userId, companyId, companyNamespace, callback) ->
    data = {
      dateTime: moment().toDate()
      user: userId
      action: 'EMPLOYEE_INVITED_INTO_COMPANY'
      company: companyId,
      ns: companyNamespace
    }
    @createActivityItem(ns, data, callback)

  employeeConfirmedInvitation: (ns, userId, companyId, companyNamespace, callback) ->
    data = {
      dateTime: moment().toDate()
      user: userId
      action: 'EMPLOYEE_CONFIRMED_COMPANY_INVITE'
      company: companyId,
      ns: companyNamespace
    }
    @createActivityItem(ns, data, callback)

  employeeWasRemovedFromCompany: (ns, userId, companyId, companyNamespace, callback) ->
    data = {
      dateTime: moment().toDate()
      user: userId
      action: 'EMPLOYEE_WAS_REMOVED_FROM_COMPANY'
      company: companyId,
      ns: companyNamespace
    }
    @createActivityItem(ns, data, callback)

module.exports = ActivityService