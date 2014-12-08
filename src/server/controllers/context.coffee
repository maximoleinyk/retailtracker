HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')

class ContextController

  constructor: (@accountService) ->

  error: (err, res) ->
    res.status(HttpStatus.BAD_REQUEST).send({errors: err})

  register: (router) ->
    router.get '/context/generate/csrf', authFilter, (req, res) =>
      res.cookie('x-csrf-token', req.csrfToken())
      res.status(HttpStatus.NO_CONTENT).end()

    router.get '/context/handshake', authFilter, (req, res) =>
      res.status(HttpStatus.NO_CONTENT).end()

    router.get '/context/load/brand', authFilter, (req, res) =>
      handler = (err, account) =>
        return res.status(HttpStatus.BAD_REQUEST).send({ error: {generic: err }}) if err
        accountData = account.toJSON()
        delete accountData.password
        delete accountData.__v
        res.status(HttpStatus.OK).send(accountData)
      @accountService.findById(req.user._id, handler).populate('owner')

    router.get '/context/load/company', authFilter, (req, res) =>
      handler = (err, account) =>
        return res.status(HttpStatus.BAD_REQUEST).send({ error: {generic: err }}) if err
        accountData = account.toJSON()
        delete accountData.password
        delete accountData.__v
        res.status(HttpStatus.OK).send(accountData)
      @accountService.findById(req.user._id, handler).populate('owner')

module.exports = ContextController