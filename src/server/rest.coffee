HttpStatus = require('http-status-codes')
security = inject('rest/security')
user = inject('rest/user')

module.exports = (router, passport) ->

  userService = inject('services/userService')(passport)

  # redirect from login page if user is authenticated
  router.get '/page/account/login', (req, res, next) ->
    if req.isAuthenticated() then res.redirect('/page') else next()

  # always return single HTML page on leading /page* part
  router.get "/page*", (req, res) ->
    res.sendFile config.app.indexHtml

  # redirect from root directory to UI
  router.get '/', (req, res) ->
    res.redirect '/page'

  router.get '/404', (req, res) ->
    res.status(HttpStatus.NOT_FOUND).end()

  # test data REST end point
  router.get '/test/data', (req, res) ->
    user = {
      firstName: 'Maksym'
      lastName: 'Oliinyk'
      email: 'maxim.oleinyk@gmail.com'
      password: 'password'
    }
    userService.create user, ->
      res.status(HttpStatus.OK).end()

  # REST handlers
  security(router, passport)
  user(router, passport)
