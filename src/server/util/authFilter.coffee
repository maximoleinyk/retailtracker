HttpStatus = require('http-status-codes')

module.exports = (req, res, next) ->
  if req.isAuthenticated() then next() else res.status(HttpStatus.UNAUTHORIZED).end()
