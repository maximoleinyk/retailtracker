HttpStatus = require('http-status-codes')

class UomController

  register: (@router, authFilter) ->
    @router.get '/uom/all', authFilter, (req, res) ->
      res.status(HttpStatus.OK).send([])

module.exports = UomController
