HttpStatus = require('http-status-codes')

module.exports = (req, res, next) ->
  regExp = /// ^
    (/page.*)
  | (/account.*)
  | (/company/invite)
  | (/i18n/messages)
  | (/security/login)
  | (favicon.ico)
  ///

  return next() if regExp.test(req.url)

  if not req.isAuthenticated()
    res.status(HttpStatus.UNAUTHORIZED).send('Unauthorized')
  else
    next()
