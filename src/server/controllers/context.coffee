HttpStatus = require('http-status-codes')
companyFilter = inject('filters/company')

class ContextController

  constructor: (@accountService) ->

  error: (err, res) ->
    res.status(HttpStatus.BAD_REQUEST).send({errors: err})

  register: (router) ->
    router.get '/context/load/brand', (req, res) =>
      handler = (err, account) =>
        return res.status(HttpStatus.BAD_REQUEST).send({ error: {generic: err }}) if err
        accountData = account.toJSON()
        delete accountData.password
        delete accountData.__v
        res.status(HttpStatus.OK).send(accountData)
      @accountService.findById(req.user._id, handler).populate('owner')

    router.get '/context/load/company', companyFilter, (req, res) =>
      handler = (err, account) =>
        return res.status(HttpStatus.BAD_REQUEST).send({ error: {generic: err }}) if err
        accountData = account.toJSON()
        delete accountData.password
        delete accountData.__v
        res.status(HttpStatus.OK).send(accountData)
      @accountService.findById(req.user._id, handler).populate('owner')

module.exports = ContextController
