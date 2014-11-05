HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')

class UserController

  constructor: (@userService) ->

  error: (err, res) ->
    res.status(HttpStatus.BAD_REQUEST).send({errors: err})

  register: (@router) ->
    @router.get '/user/fetch', authFilter, (req, res) =>
      @userService.findById req.user.owner, (err, user) =>
        return @error(err, res) if err
        res.status(HttpStatus.OK).send(user)

module.exports = UserController
