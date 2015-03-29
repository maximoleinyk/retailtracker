HttpStatus = require('http-status-codes')

module.exports = (req, res, next) ->
  if not req.isAuthenticated()
    return res.status(HttpStatus.UNAUTHORIZED).send('Unauthorized')
  else if not req.session.company
    return res.status(HttpStatus.FORBIDDEN).send('Forbidden company')
  else if req.session.pos
    return res.status(HttpStatus.FORBIDDEN).send('Forbidden pos')
  else
    next()
