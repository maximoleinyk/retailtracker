AbstractService = inject('services/abstractService')

class FormulaService extends AbstractService

  delete: (ns, id, callback) ->
    @findById ns, id, (err, document) =>
      data = document.toJSON()
      data.status = 'DELETED'
      @update(ns, data, callback)

  activate: (ns, id, callback) ->
    @findById ns, id, (err, document) ->
      return callback(err) if err
      data = document.toJSON()
      data.status = 'ACTIVATED'
      @update(ns, data, callback)

module.exports = FormulaService
