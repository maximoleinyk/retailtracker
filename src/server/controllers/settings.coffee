HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')

class SettingsController

  constructor: (@settingsService) ->

  register: (router) ->
    router.post '/settings/change/profile', authFilter, (req, res) =>
      @settingsService.changeProfile req.body, (err) ->
        return res.status(HttpStatus.BAD_REQUEST).send({errors: err}) if err
        res.status(HttpStatus.OK).end()

    router.post '/settings/change/security', authFilter, (req, res) =>
      @settingsService.changePassword req.body, (err) ->
        return res.status(HttpStatus.BAD_REQUEST).send({errors: err}) if err
        res.status(HttpStatus.OK).end()

module.exports = SettingsController
