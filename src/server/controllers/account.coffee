HttpStatus = require('http-status-codes')
_ = require('underscore')
authFilter = inject('util/authFilter')

class AccountController

  constructor: (@accountService) ->

  error: (err, res) ->
    res.status(HttpStatus.BAD_REQUEST).send({errors: err})

  register: (router) ->

    router.post '/account/password/forgot', (req, res) =>
      email = req.body.email
      @accountService.forgotPassword email, (err) =>
        if err then @error(err, res) else res.status(HttpStatus.OK).end()

    router.post '/account/password/change', (req, res) =>
      email = req.body.email
      oldPassword = req.body.oldPassword
      newPassword = req.body.newPassword
      @accountService.changePassword email, oldPassword, newPassword, (err) =>
        if err then @error(err, res) else res.status(HttpStatus.OK).end()

    router.post '/account/approve', (req, res) ->
      email = req.body.email
      link = req.body.link
      password = req.body.password
      @accountService.approve email, link, password, (err) =>
        if err then @error(err, res) else res.status(HttpStatus.OK).end()

    router.post '/account/register', (req, res) ->
      email = req.body.email
      firstName = req.body.firstName
      @accountService.register email, firstName, (err) =>
        if err then @error(err, res) else res.status(HttpStatus.OK).end()

module.exports = AccountController
