i18n = inject('i18n')
_ = require('underscore')

class ProductGroupService

  constructor: (@productGroupStore) ->
    @i18n = i18n.bundle('validation')

  search: (ns, query, callback) ->
    query = query or ''
    @findAll ns, (err, all) ->
      results = _.filter all, (item) ->
        item.name.toLowerCase().indexOf(query.toLowerCase()) > -1
      results = results.splice(0, 5)
      callback(err, results)

  create: (ns, data, callback) ->
    return callback({ name: @i18n.nameIsRequired }) if not data.name
    @productGroupStore.create ns, data, (err, result) ->
      return callback({ generic: err }) if err
      callback(null, result)

  update: (ns, data, callback) ->
    return callback({ generic: @i18n.idRequired }) if not data.id
    return callback({ name: @i18n.nameIsRequired }) if not data.name

    @productGroupStore.update ns, data, (err) ->
      return callback({ generic: err }) if err
      callback(null, data)

  findById: (ns, id, callback) ->
    @productGroupStore.findById(ns, id, callback)

  findAll: (ns, callback) ->
    @productGroupStore.findAll(ns, callback)

  delete: (ns, id, callback) ->
    return callback({ generic: @i18n.idRequired }) if not id
    @productGroupStore.delete ns, id, (err) ->
      return callback({ generic: err }) if err
      callback(null)

module.exports = ProductGroupService