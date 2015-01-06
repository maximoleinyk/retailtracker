i18n = inject('i18n')

class CounterpartyService

  constructor: (@counterpartyStore) ->
    @i18n = i18n.bundle('validation')

  findAll: (ns, callback) ->
    @counterpartyStore.findAll(ns, callback)

  findById: (ns, id, callback) ->
    @counterpartyStore.findById(ns, id, callback)

  create: (ns, data, callback) ->
    # TODO: why validation is here despite Model fields having 'required' attribute and type?
    #return callback({ name: @i18n.nameIsRequired }) if not data.name
    #return callback({ code: @i18n.codeIsRequired }) if not data.code
    #return callback({ rate: @i18n.rateIsRequired }) if not data.rate
    #return callback({ rate: @i18n.rateShouldBeNumeric }) if typeof data.rate isnt 'number'

    @counterpartyStore.create ns, data, (err, result) ->
      return callback({ generic: err }) if err
      callback(null, result)

  delete: (ns, id, callback) ->
    return callback({ generic: @i18n.idRequired }) if not id
    @counterpartyStore.delete ns, id, (err) ->
      return callback({ generic: err }) if err
      callback(null)

  update: (ns, data, callback) ->
    # TODO: validation is duplicated, move to a separate method (if needed)
    # return callback({ name: @i18n.nameIsRequired }) if not data.name
    # return callback({ code: @i18n.codeIsRequired }) if not data.code
    # return callback({ rate: @i18n.rateIsRequired }) if not data.rate
    # return callback({ rate: @i18n.rateShouldBeNumeric }) if typeof data.rate isnt 'number'

    @counterpartyStore.update ns, data, (err) ->
      return callback({ generic: err }) if err
      callback(null, data)

module.exports = CounterpartyService
