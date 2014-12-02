i18n = inject('i18n')
_ = require('underscore')
Promise = inject('util/promise')

class NomenclatureService

  constructor: (@uomService, @productGroupService, @nomenclatureStore) ->
    @i18n = i18n.bundle('validation')

  findAll: (ns, callback) ->
    @nomenclatureStore.findAll ns, (err, results) =>
      return callback(err) if err
      populate = Promise.all _.map results, (doc) =>
        document = doc.toJSON()
        pairs = []
        if document.uom
          pairs.push new Promise (resolve, reject) =>
            @uomService.findById ns, document.uom, (err, uom) ->
              return reject(err) if err
              document.uom = uom
              resolve()

        if document.productGroup
          pairs.push new Promise (resolve, reject) =>
            @productGroupService.findById ns, document.productGroup, (err, productGroup) ->
              return reject(err) if err
              document.productGroup = productGroup
              resolve()

        if pairs.length
          Promise.all(pairs)
          .then ->
            Promise.empty(document)
        else
          Promise.empty(document)

      populate
      .then (results) ->
        callback(null, results[0])
      .then(null, callback)

  findById: (ns, id, callback) ->
    @nomenclatureStore.findById ns, id, (err, doc) =>
      return callback(err) if err
      return callback('Not found') if not doc

      document = doc.toJSON()
      pairs = []

      if document.uom
        pairs.push new Promise (resolve, reject) =>
          @uomService.findById ns, document.uom, (err, uom) ->
            return reject(err) if err
            document.uom = uom
            resolve()

      if document.productGroup
        pairs.push new Promise (resolve, reject) =>
          @productGroupService.findById ns, document.productGroup, (err, productGroup) ->
            return reject(err) if err
            document.productGroup = productGroup
            resolve()

      if pairs.length
        promise = Promise.all(pairs)
      else
        promise = Promise.empty()

      promise
      .then ->
        callback(null, document)
      .catch(callback)

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