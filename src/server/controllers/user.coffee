HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')

class UserController

  constructor: (@userService) ->

  error: (err, res) ->
    res.status(HttpStatus.BAD_REQUEST).send({errors: err})

  register: (@router) ->
    # does nothing

module.exports = UserController
