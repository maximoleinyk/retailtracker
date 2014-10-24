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

Promise.all = ->
  Q.all.apply(Q, arguments)

module.exports = Promise