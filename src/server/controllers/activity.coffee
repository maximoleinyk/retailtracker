HttpStatus = require('http-status-codes')
namespace = inject('util/namespace')

class ActivityController

  constructor: (@activityService) ->

  register: (router) ->
    router.get '/activity/fetch', (req, res) =>
      @activityService.fetch namespace.account(req), (err, list) =>
        if err then res.status(HttpStatus.BAD_REQUEST).send({errors: err}) else res.status(HttpStatus.OK).send(list)

module.exports = ActivityController
