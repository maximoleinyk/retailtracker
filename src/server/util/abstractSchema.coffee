mongoose = require('mongoose')
_ = require('underscore')

class AbstractSchema

  get: (namespace) ->
    args = [@getName(), @getSchema()]
    if namespace and _.isFunction(namespace)
      args.push(namespace(@getCollectionName()))
    else
      args.push(@getCollectionName())
    mongoose.model.apply(mongoose, args);

  getCollectionName: ->
    # abstract method

  getSchema: ->
    # abstract method

  getName: ->
    # abstract method

module.exports = AbstractSchema