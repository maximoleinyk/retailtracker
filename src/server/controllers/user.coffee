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

        account = req.user.toJSON()
        delete account.password
        delete account.login
        account.owner = user.toJSON()

        res.status(HttpStatus.OK).send(account)

module.exports = UserController
