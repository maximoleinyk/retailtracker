HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')

class ActivityController

  constructor: (@activityService) ->

  error: (err, res) ->
    res.status(HttpStatus.BAD_REQUEST).send({errors: err})

  register: (router) ->
    router.get '/activity/fetch', authFilter, (req, res) =>
      @activityService.fetch namespace.account(req), (err, list) =>
        if err then @error(err, res) else res.status(HttpStatus.OK).send(list)

module.exports = ActivityController