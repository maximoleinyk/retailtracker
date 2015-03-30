HttpStatus = require('http-status-codes')

module.exports = (req, res, next) ->
  if not req.session.pos
    res.status(HttpStatus.FORBIDDEN).send('Forbidden pos')
  else
    next()

