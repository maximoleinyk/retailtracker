HttpStatus = require('http-status-codes')
userService = inject('services/userService')
crypto = require('crypto')

module.exports = (router) ->
  router.get '/test/data', (req, res) ->
    user = {
      firstName: 'Maksym'
      lastName: 'Oliinyk'
      email: 'maxim.oleinyk@gmail.com'
      password: crypto.createHash('md5').update('password').digest('hex')
    }
    userService.create(user)
    res.status(HttpStatus.OK).end()

  router.get '/user/fetch', (req, res) ->
    res.status(HttpStatus.OK).send(req.user)
