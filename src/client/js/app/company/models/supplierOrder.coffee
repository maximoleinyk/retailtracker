define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  Promise = require('rsvp').Promise

  class SupplierOrder extends Model

    urlRoot: '/supplierorders'

    save: ->
      save = new Promise (resolve, reject) =>
        Model::save.apply(this, @toJSON()).done(resolve).fail(reject)
      save.then (result) =>
        @set @parse(result)
        @commit()
