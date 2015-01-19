i18n = inject('util/i18n').bundle('validation')
Promise = inject('util/promise')

class RoleService

  constructor: (@roleStore) ->

  findById: (ns, roleId, callback) ->
    @roleStore.findById(ns, roleId, callback)

  findByName: (ns, roleName, callback) ->
    @roleStore.findByName(ns, roleName, callback)

  findAll: (ns, callback) ->
    findRoles = new Promise (resolve, reject) =>
      @roleStore.findAll ns, (err, result) ->
        if err then reject(err) else resolve(result)

    findRoles
    .then (result) =>
      callback(null, result)

    .catch(callback)

  findAllAvailable: (ns, callback) ->
    findRoles = new Promise (resolve, reject) =>
      @roleStore.findAllAvailable ns, (err, result) ->
        if err then reject(err) else resolve(result)

    findRoles
    .then (result) =>
      callback(null, result)

    .catch(callback)

  create: (ns, data, callback) ->
    return callback({ name: i18n.nameIsRequired }) if not data.name

    create = new Promise (resolve, reject) =>
      @roleStore.create ns, data, (err, result) ->
        if err then reject(err) else resolve(result)

    create
    .then (response) ->
      callback(null, response)
    .catch(callback)

module.exports = RoleService
