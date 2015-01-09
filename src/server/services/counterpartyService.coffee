i18n = inject('i18n')
_ = require('underscore')

class CounterpartyService

  constructor: (@counterpartyStore) ->
    @i18n = i18n.bundle('validation')

  findAll: (ns, callback) ->
    @counterpartyStore.findAll(ns, callback)

  findById: (ns, id, callback) ->
    @counterpartyStore.findById(ns, id, callback)

  wrapCallback: (callback) ->
    (err, result) =>
      if (err)
        if (err.name == 'ValidationError')
          callback(_.object(_.map(err.errors, (error, name) =>
            [name, @i18n['validation.' + error.type]]
          )))
        else
          callback({ generic: err })
      callback(null, result)

  create: (ns, data, callback) ->
    @counterpartyStore.create ns, data, @wrapCallback(callback)

  delete: (ns, id, callback) ->
    return callback({ generic: @i18n.idRequired }) if not id
    @counterpartyStore.delete ns, id, @wrapCallback(callback)

  update: (ns, data, callback) ->
    @counterpartyStore.update ns, data, @wrapCallback(callback)

module.exports = CounterpartyService
