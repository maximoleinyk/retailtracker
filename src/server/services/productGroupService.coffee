i18n = inject('util/i18n').bundle('validation')
AbstractService = inject('services/abstractService')

class ProductGroupService extends AbstractService

  create: (ns, data, callback) ->
    return callback({ name: i18n.nameIsRequired }) if not data.name
    super

  update: (ns, data, callback) ->
    return callback({ generic: i18n.idRequired }) if not data.id
    return callback({ name: i18n.nameIsRequired }) if not data.name
    super

  delete: (ns, id, callback) ->
    return callback({ generic: i18n.idRequired }) if not id
    super

module.exports = ProductGroupService
