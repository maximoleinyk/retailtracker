HttpStatus = require('http-status-codes')
authFilter= inject('util/authFilter')

module.exports = (router, passport) ->

  userService = inject('services/userService')(passport)

  router.get '/test/data', (req, res) ->
    user = {
      firstName: 'Maksym'
      lastName: 'Oliinyk'
      email: 'maxim.oleinyk@gmail.com'
      password: 'password'
    }
    userService.create user, ->
      res.status(HttpStatus.OK).end()

  router.get '/user/fetch', authFilter, (req, res) ->
    res.status(HttpStatus.OK).send(req.user)
