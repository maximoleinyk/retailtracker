i18n = inject('i18n')

class ProductGroupService

  constructor: (@productGroupStore) ->
    @i18n = i18n.bundle('validation')

  create: (ns, data, callback) ->
    return callback({ name: @i18n.nameIsRequired }) if not data.name
    @productGroupStore.create ns, data, (err, result) ->
      return callback({ generic: err }) if err
      callback(null, result)

  update: (ns, data, callback) ->
    return callback({ generic: @i18n.idRequired }) if not id
    return callback({ name: @i18n.nameIsRequired }) if not data.name

    @productGroupStore.update ns, data, (err) ->
      return callback({ generic: err }) if err
      callback(null, data)

  findAll: (ns, callback) ->
    @productGroupStore.findAll(ns, callback)

  delete: (ns, id, callback) ->
    return callback({ generic: @i18n.idRequired }) if not id
    @productGroupStore.delete ns, id, (err) ->
      return callback({ generic: err }) if err
      callback(null)

module.exports = ProductGroupService