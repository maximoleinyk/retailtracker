AbstractStore = inject('persistence/abstractStore')

class FormulaStore extends AbstractStore

  search: (ns, query = '', limit = 5, callback) ->
    @model.get(ns).find({
      state: 'ACTIVATED'
      name: new RegExp(query, 'i')
    }).limit(limit).exec(callback)

  findById: (ns, id, callback) ->
    @model.get(ns).findOne({state: {'$ne': 'DELETED'}, _id: id}, @callback(callback)).populate('currency')

  findAll: (ns, callback) ->
    @model.get(ns).find({state: {'$ne': 'DELETED'}}, @callback(callback)).populate('currency')

module.exports = FormulaStore
