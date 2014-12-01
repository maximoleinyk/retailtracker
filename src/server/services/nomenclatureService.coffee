i18n = inject('i18n')
_ = require('underscore')

class NomenclatureService

  constructor: (@uomService, @productGroupService, @nomenclatureStore) ->
    @i18n = i18n.bundle('validation')

  findAll: (ns, callback) ->
    @nomenclatureStore.findAll ns, (err, results) =>
      insertUoms = Promise.all _.map results, (doc) =>
        if doc.uom
          return new Promise (resolve, reject) =>
            @uomService.findById ns, doc.uom, (err, uom) ->
              return reject(err) if err
              doc.uom = uom
              resolve(doc)
        else
          return Promise.empty(doc)

      insertUoms
      .then (results) =>
        Promise.all _.map results, (doc) =>
          if doc.productGroup
            return new Promise (resolve, reject) =>
              @productGroupService.findById ns, doc.productGroup, (err, productGroup) ->
                return reject(err) if err
                doc.productGroup = productGroup
                resolve(doc)
          else
            return Promise.empty(doc)

      .then (results) ->
        callback(null, results)
      .then(null, callback)

  findById: (ns, id, callback) ->
    @nomenclatureStore.findById(ns, id, callback)

  create: (ns, data, callback) ->
    return callback({ name: @i18n.nameIsRequired }) if not data.name

    @nomenclatureStore.create ns, data, (err, result) ->
      return callback({ generic: err }) if err
      callback(null, result)

  delete: (ns, id, callback) ->
    return callback({ generic: @i18n.idRequired }) if not id
    @nomenclatureStore.delete ns, id, (err) ->
      return callback({ generic: err }) if err
      callback(null)

  update: (ns, data, callback) ->
    return callback({ name: @i18n.nameIsRequired }) if not data.name

    @nomenclatureStore.update ns, data, (err) ->
      return callback({ generic: err }) if err
      callback(null, data)

module.exports = NomenclatureService