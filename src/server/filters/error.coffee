module.exports = (err, req, res, next) ->
  if err.code is 'EBADCSRFTOKEN'
    return next() if req.url is '/security/login'
    res.status(403).send('CSRF has expired')
  else
    next(err)
