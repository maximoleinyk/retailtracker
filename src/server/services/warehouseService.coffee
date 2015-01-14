i18n = inject('util/i18n').bundle('validation')
_ = require('underscore')

class UomService

  constructor: (@warehouseStore) ->

  search: (ns, query, callback) ->
    query = query or ''
    @findAll ns, (err, all) ->
      results = _.filter all, (item) ->
        item.name.toLowerCase().indexOf(query.toLowerCase()) > -1
      results = results.splice(0, 5)
      callback(err, results)

  findById: (ns, id, callback) ->
    @warehouseStore.findById(ns, id, callback)

  findAll: (ns, callback) ->
    @warehouseStore.findAll(ns, callback)

  delete: (ns, id, callback) ->
    return callback({ generic: i18n.idRequired }) if not id
    @warehouseStore.delete ns, id, (err) ->
      return callback({ generic: err }) if err
      callback(null)

  update: (ns, data, callback) ->
    return callback({ name: i18n.nameRequired }) if not data.name
    @warehouseStore.update ns, data, (err) ->
      return callback({ generic: err }) if err
      callback(null, data)

  create: (ns, data, callback) ->
    return callback({ name: i18n.nameRequired }) if not data.name
    @warehouseStore.create ns, data, (err, result) ->
      return callback({ generic: err }) if err
      callback(null, result)

module.exports = UomService
