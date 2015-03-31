HttpStatus = require('http-status-codes')

module.exports = (req, res, next) ->
  if req.session.company isnt req.headers.company
    res.status(HttpStatus.FORBIDDEN).send('Unknown company')
  else
    next()

