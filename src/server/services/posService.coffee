_ = require('underscore')
AbstractService = inject('services/abstractService')
Promise = inject('util/promise')

class PosService extends AbstractService

  start: (ns, data, callback) ->
    return callback({employee: 'Employee id must be specified'}) if not data.employee
    return callback({pos: 'Pos id must be specified'}) if not data.pos

    loadPos = new Promise (resolve, reject) =>
      @store.findById ns, data.pos, (err, result) ->
        if err then reject(err) else resolve(result)

    loadPos.then (result) ->
      callback(null, result)
    .catch(callback)

  fetchAllowed: (ns, data, callback) ->
    return callback({employee: 'Employee id must be specified'}) if not data.employee
    return callback({store: 'Store id must be specified'}) if not data.store

    loadPos = new Promise (resolve, reject) =>
      @store.findAllowedPos ns, data.employee, data.store, (err, result) ->
        if err then reject(err) else resolve(result)

    loadPos.then (result) =>
      callback(null, result)

    .catch(callback)

  update: (ns, data) ->
    cashiers = []

    _.each data.cashiers, (cashier) ->
      cashiers.push if _.isObject(cashier) then cashier._id or cashier.id else cashier

    data.store = if _.isObject(data.store) then data.store._id else data.store
    data.cashiers = cashiers

    super

module.exports = PosService
