i18n = inject('util/i18n').bundle('validation')
AbstractService = inject('services/abstractService')

class UomService extends AbstractService

  delete: (ns, id, callback) ->
    return callback({ generic: i18n.idRequired }) if not id
    super

  update: (ns, data, callback) ->
    return callback({ shortName: i18n.shortNameRequired }) if not data.shortName
    super

  create: (ns, data, callback) ->
    return callback({ shortName: i18n.shortNameRequired }) if not data.shortName
    super

module.exports = UomService
