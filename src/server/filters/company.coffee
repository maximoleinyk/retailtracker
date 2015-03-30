HttpStatus = require('http-status-codes')

module.exports = (req, res, next) ->
  if not req.session.company
    res.status(HttpStatus.FORBIDDEN).send('Forbidden company')
  else
    next()

