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
      throw {generic: 'You don\'t have permission for pos terminals'} if not result.length
      callback(null, result)

    .catch(callback)

module.exports = PosService
