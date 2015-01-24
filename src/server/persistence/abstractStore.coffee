_ = require('underscore')
i18n = inject('util/i18n').bundle('validation')

class AbstractStore

  constructor: (Model) ->
    @model = new Model

  callback: (callback) ->
    (err) =>
      if (err)
        if (err.name == 'ValidationError')
          callback(_.object(_.map(err.errors, (error, name) =>
            [name, i18n['validation.' + error.type] || error.message]
          )))
        else
          callback({ generic: err })
      else
        callback.apply(this, arguments)

  create: (ns, data, callback) ->
    ConcreteModel = @model.get(ns)

    instance = new ConcreteModel(data)
    instance.save(@callback(callback))

  delete: (ns, id, callback) ->
    @model.get(ns).findByIdAndRemove(id, @callback(callback))

  update: (ns, data, callback) ->
    # Mongoose 3.9.3 requires for runValidators option support
    @model.get(ns).update {_id: data.id or data._id}, _.omit(data, ['id, _id']), {runValidators: true}, (err) =>
      return @callback(callback) if err
      @findById(ns, data.id, @callback(callback))

  findById: (ns, id, callback) ->
    @model.get(ns).findById(id, @callback(callback))

  findAll: (ns, callback) ->
    @model.get(ns).find({}, @callback(callback))

module.exports = AbstractStore
