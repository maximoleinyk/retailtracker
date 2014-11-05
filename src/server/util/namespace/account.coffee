module.exports = (req) ->
  (collectionName) ->
    req.session.ns + '.' + collectionName