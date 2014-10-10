class UomService

  constructor: (@uomStore) ->

  findAll: (callback) ->
    @uomStore.findAll(callback)

  create: (data, callback) ->
    return callback({ name: 'Name must be specified' }) if not data.name
    @uomStore.create data, (err, result) ->
      return callback({ generic: err }) if err
      callback(null, result)

module.exports = UomService