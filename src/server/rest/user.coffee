HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
userService = inject('services/userService')

module.exports = (router) ->

  router.get '/user/fetch', authFilter, (req, res) ->
    res.status(HttpStatus.OK).send(req.user)
