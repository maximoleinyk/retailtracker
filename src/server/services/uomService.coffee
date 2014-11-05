i18n = inject('i18n')

class UomService

  constructor: (@uomStore) ->
    @i18n = i18n.bundle('validation')

  findAll: (callback) ->
    @uomStore.findAll(callback)

  delete: (id, callback) ->
    return callback({ generic: @i18n.idRequired }) if not id
    @uomStore.delete id, (err) ->
      return callback({ generic: err }) if err
      callback(null)

  update: (data, callback) ->
    return callback({ shortName: @i18n.shortNameRequired }) if not data.shortName
    @uomStore.update data, (err, result) ->
      return callback({ generic: err }) if err
      callback(null, result)

  create: (data, callback) ->
    return callback({ shortName: @i18n.shortNameRequired }) if not data.shortName
    @uomStore.create data, (err, result) ->
      return callback({ generic: err }) if err
      callback(null, result)

module.exports = UomService