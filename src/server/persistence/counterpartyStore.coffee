Model = inject('persistence/model/counterparty')
_ = require('underscore')
i18n = inject('i18n').bundle('validation')

class CounterpartyStore

  constructor: ->
    @model = new Model

  wrapCallback: (callback) ->
    (err) =>
      if (err)
        if (err.name == 'ValidationError')
          callback(_.object(_.map(err.errors, (error, name) =>
            [name, i18n[error.type]]
          )))
        else
          callback({ generic: err })
      callback.apply(this, arguments)

  create: (ns, data, callback) ->
    Counterparty = @model.get(ns)

    counterparty = new Counterparty(data)
    counterparty.save(@wrapCallback(callback))

  delete: (ns, id, callback) ->
    @model.get(ns).findByIdAndRemove(id, @wrapCallback(callback))

  update: (ns, data, callback) ->
    @model.get(ns).update({_id: data.id or data._id}, _.omit(data, ['_id']), @wrapCallback(callback))

  findById: (ns, id, callback) ->
    @model.get(ns).findById(id, @wrapCallback(callback))

  findAll: (ns, callback) ->
    @model.get(ns).find({}, @wrapCallback(callback))

module.exports = CounterpartyStore
