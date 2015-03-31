HttpStatus = require('http-status-codes')

module.exports = (req, res, next) ->
  if req.headers.pos isnt req.session.pos
    res.status(HttpStatus.FORBIDDEN).send('Unknown pos')
  else
    next()

