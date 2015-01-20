i18n = inject('util/i18n').bundle('validation')

class AbstractService

  constructor: (@store) ->

  findAll: (ns, callback) ->
    @store.findAll(ns, callback)

  findById: (ns, id, callback) ->
    @store.findById(ns, id, callback)

  create: (ns, data, callback) ->
    @store.create ns, data, callback

  delete: (ns, id, callback) ->
    return callback({ generic: i18n.idRequired }) if not id
    @store.delete ns, id, callback

  update: (ns, data, callback) ->
    @store.update ns, data, (err) ->
      return callback(err) if err
      callback(null, data)

module.exports = AbstractService
