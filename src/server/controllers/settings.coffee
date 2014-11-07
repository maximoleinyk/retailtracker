HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')

class SettingsController

  constructor: (@settingsService) ->

  error: (err, res) ->
    res.status(HttpStatus.BAD_REQUEST).send({errors: err})

  register: (router) ->
    router.post '/settings/change/profile', authFilter, (req, res) =>
      @settingsService.changeProfile req.body, (err) =>
        if err then @error(err, res) else res.status(HttpStatus.OK).end()

    router.post '/settings/change/security', authFilter, (req, res) =>
      userId = req.body.id
      oldPassword = req.body.oldPassword
      newPassword = req.body.password
      @settingsService.changePassword userId, oldPassword, newPassword, (err) =>
        if err then @error(err, res) else res.status(HttpStatus.OK).end()

module.exports = SettingsController
