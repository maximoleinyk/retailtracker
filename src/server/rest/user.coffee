HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')

module.exports = (router, passport) ->
  userService = inject('services/userService')(passport)

  router.get '/user/fetch', authFilter, (req, res) ->
    res.status(HttpStatus.OK).send(req.user)
