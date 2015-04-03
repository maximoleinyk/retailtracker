express = require('express')
i18n = inject('util/i18n')

module.exports = ->
  router = express.Router()

  # redirect from root directory to UI
  router.get '/', (req, res) ->
    res.redirect '/page/account/login'

  # redirect from login page if user is authenticated
  router.get '/page/account/login', (req, res, next) ->
    if req.isAuthenticated()
      res.redirect('/page/brand')
    else
      next()

  router.get '/page', (req, res) ->
    res.redirect('/page/account/login')

  # always return single HTML page on leading /page* part
  router.get "/page*", (req, res) ->
    res.cookie('X-Csrf-Token', req.csrfToken())
    res.sendFile(global.config.app.indexHtml)

  router.get '/i18n/messages/:batch', (req, res) =>
    res.send(i18n.bundle(req.params.batch))

  router
