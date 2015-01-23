define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  Promise = require('rsvp').Promise

  class Store extends Model

    urlRoot: '/store'

    save: ->
      save = new Promise (resolve, reject) =>
        Model::save.apply(this, @toJSON()).done(resolve).fail(reject)
      save.then (result) =>
        @set @parse(result)
        @commit()

    destroy: ->
      destroy = new Promise (resolve, reject) =>
        Model::destroy.apply(this).done(resolve).fail(reject)
      destroy.then (result) =>
        @set @parse(result)
        @commit()
