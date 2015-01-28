HttpStatus = require('http-status-codes')
_ = require('underscore')
authFilter = inject('util/authFilter')

class AccountController

  constructor: (@accountService) ->

  error: (err, res) ->
    res.status(HttpStatus.BAD_REQUEST).send({errors: err})

  register: (router) ->
    router.post '/account/password/confirm', (req, res) =>
      key = req.body.key
      newPassword = req.body.password
      @accountService.changeForgottenPassword key, newPassword, (err) =>
        if err then @error(err, res) else res.status(HttpStatus.NO_CONTENT).end()

    router.post '/account/password/forgot', (req, res) =>
      email = req.body.email
      @accountService.forgotPassword email, (err) =>
        if err then @error(err, res) else res.status(HttpStatus.NO_CONTENT).end()

    router.post '/account/password/change', (req, res) =>
      email = req.body.email
      oldPassword = req.body.oldPassword
      newPassword = req.body.newPassword
      @accountService.changePassword email, oldPassword, newPassword, (err) =>
        if err then @error(err, res) else res.status(HttpStatus.NO_CONTENT).end()

    router.post '/account/register/confirm', (req, res) =>
      link = req.body.link
      password = req.body.password
      @accountService.approveRegistration link, password, (err) =>
        if err then @error(err, res) else res.status(HttpStatus.NO_CONTENT).end()

    router.post '/account/register', (req, res) =>
      email = req.body.email
      firstName = req.body.firstName
      @accountService.register email, firstName, (err) =>
        if err then @error(err, res) else res.status(HttpStatus.NO_CONTENT).end()

    router.post '/account/invite/confirm', (req, res) =>
      inviteKey = req.body.key
      newPassword = req.body.password
      @accountService.confirmCompanyInvite inviteKey, newPassword, (err) =>
        if err then @error(err, res) else res.status(HttpStatus.NO_CONTENT).end()

module.exports = AccountController
