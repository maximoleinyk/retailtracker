HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')

class UserController

  register: (@router) ->
    @router.get '/user/fetch', authFilter, (req, res) ->
      res.status(HttpStatus.OK).send(req.user.owner)

module.exports = UserController
