i18n = inject('util/i18n').bundle('validation')

class AbstractService

  constructor: (@store) ->

  findAll: (ns, callback) ->
    @store.findAll(ns, callback)

  findById: (ns, id, callback) ->
    @store.findById(ns, id, callback)

  create: (ns, data, callback) ->
    @store.create(ns, data, callback)

  update: (ns, data, callback) ->
    @store.update(ns, data, callback)

  delete: (ns, id, callback) ->
    @store.delete(ns, id, callback)

  search: (ns, query, limit, callback) ->
    @store.search(ns, query, limit, callback)

module.exports = AbstractService
