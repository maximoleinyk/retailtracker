Q = require('q')

class Promise

  constructor: (callback) ->
    deferred = Q.defer()
    resolve = ->
      deferred.resolve.apply(deferred, arguments)
    reject = ->
      deferred.reject.apply(deferred, arguments)
    callback(resolve, reject)
    return deferred.promise

  @all = ->
    Q.all.apply(Q, arguments)

  @empty: (value) ->
    Q.when(value)

module.exports = Promise
