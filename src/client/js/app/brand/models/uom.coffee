define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/mongoModel')

  class Uom extends MongoModel

    create: (callback) ->
      @request('post', '/uom/create', @toJSON())
      .then (result) =>
        @set(result, {parse: true})
        callback(null, @)
      .then(null, callback)
