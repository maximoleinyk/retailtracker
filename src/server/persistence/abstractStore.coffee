_ = require('underscore')
i18n = inject('util/i18n').bundle('validation')

class AbstractStore

  wrapCallback: (callback) ->
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
    instance.save(@wrapCallback(callback))

  delete: (ns, id, callback) ->
    @model.get(ns).findByIdAndRemove(id, @wrapCallback(callback))

  update: (ns, data, callback) ->
    # TODO: Mongoose 3.9.3 is required for runValidators option support
    @model.get(ns).update({_id: data.id or data._id}, _.omit(data, ['_id']), {runValidators: true}, @wrapCallback(callback))

  findById: (ns, id, callback) ->
    @model.get(ns).findById(id, @wrapCallback(callback))

  findAll: (ns, callback) ->
    @model.get(ns).find({}, @wrapCallback(callback))

module.exports = AbstractStore
