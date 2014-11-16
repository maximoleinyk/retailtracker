HttpStatus = require('http-status-codes')

module.exports = (req, res, next) ->
  refererPath = req.headers['referer'].split(req.get('host'))[1]
  companyRegexp = /^\/page\/company\/.*/i

  if not req.isAuthenticated()
    return res.status(HttpStatus.UNAUTHORIZED).send('Unauthorized')
  else if companyRegexp.test(refererPath) and not req.headers['company']
    return res.status(HttpStatus.UNAUTHORIZED).send('Unknown context')

  next()
