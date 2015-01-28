HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')

class SettingsController

  constructor: (@settingsService) ->

  error: (err, res) ->
    res.status(HttpStatus.BAD_REQUEST).send({errors: err})

  register: (router) ->
    router.put '/settings/profile/:accountOwnerId', authFilter, (req, res) =>
      @settingsService.changeProfile req.body, (err) =>
        if err then @error(err, res) else res.status(HttpStatus.NO_CONTENT).end()

    router.put '/settings/password/:accountOwnerId', authFilter, (req, res) =>
      @settingsService.changePassword req.body.id, req.body.oldPassword, req.body.password, (err) =>
        if err then @error(err, res) else res.status(HttpStatus.NO_CONTENT).end()

module.exports = SettingsController
