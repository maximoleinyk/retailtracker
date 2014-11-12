_ = require('underscore')

module.exports = (req) ->
  (collectionName) ->
    (if _.isString(req) then req else req.session.ns) + (collectionName ? '.' + collectionName : '')