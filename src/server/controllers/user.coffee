HttpStatus = require('http-status-codes')

class UserController

  register: (@router, authFilter) ->
    @router.get '/user/fetch', authFilter, (req, res) ->
      res.status(HttpStatus.OK).send(req.user)

module.exports = UserController
