i18n = inject('i18n')
_ = require('underscore')

class CounterpartyService

  constructor: (@counterpartyStore) ->
    @i18n = i18n.bundle('validation')

  findAll: (ns, callback) ->
    @counterpartyStore.findAll(ns, callback)

  findById: (ns, id, callback) ->
    @counterpartyStore.findById(ns, id, callback)

  create: (ns, data, callback) ->
    @counterpartyStore.create ns, data, callback

  delete: (ns, id, callback) ->
    return callback({ generic: @i18n.idRequired }) if not id
    @counterpartyStore.delete ns, id, callback

  update: (ns, data, callback) ->
    @counterpartyStore.update ns, data, (err) ->
      return callback(err) if err
      callback(null, data)

module.exports = CounterpartyService
