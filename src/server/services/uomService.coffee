i18nService = inject('services/i18nService')

class UomService

  constructor: (@uomStore) ->
    @i18n = i18nService.bundle('validation')

  findAll: (callback) ->
    @uomStore.findAll(callback)

  delete: (id, callback) ->
    return callback({ generic: @i18n.idRequired }) if not id
    @uomStore.delete id, (err) ->
      return callback({ generic: err }) if err
      callback(null)

  update: (data, callback) ->
    return callback({ name: @i18n.nameRequired }) if not data.name
    @uomStore.update data, (err, result) ->
      return callback({ generic: err }) if err
      callback(null, result)

  create: (data, callback) ->
    return callback({ name: @i18n.nameRequired }) if not data.name
    @uomStore.create data, (err, result) ->
      return callback({ generic: err }) if err
      callback(null, result)

module.exports = UomService