HttpStatus = require('http-status-codes')
security = inject('rest/security')
user = inject('rest/user')

module.exports = (router, passport) ->

  # redirect from login page if user is authenticated
  router.get '/page/account/login', (req, res, next) ->
    if req.isAuthenticated() then res.redirect('/page') else next()

  # always return single HTML page on leading /ui* part
  router.get "/page*", (req, res) ->
    res.sendFile config.app.indexHtml

  # redirect from root directory to UI
  router.get '/', (req, res) ->
    res.redirect '/page'

  router.get '/404', (req, res) ->
    res.status(404).end();

  # REST handlers
  security(router, passport)
  user(router, passport)
