HttpStatus = require('http-status-codes')

module.exports = (err, req, res, next) ->
  if err.code is 'EBADCSRFTOKEN'
    if req.url is '/security/login'
      next()
    else
      res.status(HttpStatus.FORBIDDEN).send('CSRF has expired')
  else
    next(err)
