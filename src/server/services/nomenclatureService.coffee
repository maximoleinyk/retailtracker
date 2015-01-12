i18n = inject('i18n').bundle('validation')
_ = require('underscore')
Promise = inject('util/promise')

class NomenclatureService

  constructor: (@uomService, @productGroupService, @nomenclatureStore) ->

  findAll: (ns, callback) ->
    @nomenclatureStore.findAll(ns, callback).populate('uom productGroup')

  findById: (ns, id, callback) ->
    @nomenclatureStore.findById(ns, id, callback).populate('uom productGroup')

  create: (ns, data, callback) ->
    return callback({ name: i18n.nameIsRequired }) if not data.name

    @nomenclatureStore.create ns, data, (err, result) ->
      return callback({ generic: err }) if err
      callback(null, result)

  delete: (ns, id, callback) ->
    return callback({ generic: i18n.idRequired }) if not id
    @nomenclatureStore.delete ns, id, (err) ->
      return callback({ generic: err }) if err
      callback(null)

  update: (ns, data, callback) ->
    return callback({ name: i18n.nameIsRequired }) if not data.name

    @nomenclatureStore.update ns, data, (err) ->
      return callback({ generic: err }) if err
      callback(null, data)

module.exports = NomenclatureService
