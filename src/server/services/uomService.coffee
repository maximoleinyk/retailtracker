i18n = inject('i18n')
_ = require('underscore')

class UomService

  constructor: (@uomStore) ->
    @i18n = i18n.bundle('validation')

  search: (ns, query, callback) ->
    query = query or ''
    @findAll ns, (err, all) ->
      results = _.filter all, (item) ->
        item.shortName.toLowerCase().indexOf(query.toLowerCase()) > -1
      results = results.splice(0, 5)
      callback(err, results)

  findAll: (ns, callback) ->
    @uomStore.findAll(ns, callback)

  delete: (ns, id, callback) ->
    return callback({ generic: @i18n.idRequired }) if not id
    @uomStore.delete ns, id, (err) ->
      return callback({ generic: err }) if err
      callback(null)

  update: (ns, data, callback) ->
    return callback({ shortName: @i18n.shortNameRequired }) if not data.shortName
    @uomStore.update ns, data, (err) ->
      return callback({ generic: err }) if err
      callback(null, data)

  create: (ns, data, callback) ->
    return callback({ shortName: @i18n.shortNameRequired }) if not data.shortName
    @uomStore.create ns, data, (err, result) ->
      return callback({ generic: err }) if err
      callback(null, result)

module.exports = UomService