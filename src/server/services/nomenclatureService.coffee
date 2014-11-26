i18n = inject('i18n')

class NomenclatureService

  constructor: (@nomenclatureStore) ->
    @i18n = i18n.bundle('validation')

  findAll: (ns, callback) ->
    @nomenclatureStore.findAll(ns, callback)

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