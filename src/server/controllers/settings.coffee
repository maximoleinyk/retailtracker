HttpStatus = require('http-status-codes')

class SettingsController

  constructor: (@settingsService) ->

  error: (err, res) ->
    res.status(HttpStatus.BAD_REQUEST).send({errors: err})

  register: (router) ->
    router.post '/settings/profile', (req, res) =>
      @settingsService.changeProfile req.body, (err) =>
        if err then @error(err, res) else res.status(HttpStatus.NO_CONTENT).end()

    router.post '/settings/password', (req, res) =>
      @settingsService.changePassword req.body.userId, req.body.oldPassword, req.body.password, (err) =>
        if err then @error(err, res) else res.status(HttpStatus.NO_CONTENT).end()

module.exports = SettingsController
