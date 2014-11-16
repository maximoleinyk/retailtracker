_ = require('underscore')

module.exports = (req) ->
  (collectionName) ->
    account = if _.isString(req) then req else req.headers.account
    collection = if collectionName and account then '.' + collectionName else ''

    account + collection