_ = require('underscore')

module.exports = (req) ->
  (collection) ->
    req.headers.account + '.' + req.headers.company + '.' + collection