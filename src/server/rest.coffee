HttpStatus = require('http-status-codes')
EmailService = inject('services/emailService')
TemplateService = inject('services/templateService')
security = inject('rest/security')
user = inject('rest/user')

module.exports = (router, passport, config) ->

  # always return single HTML page on leading /ui* part
  router.get "/ui*", (req, res) ->
    res.sendFile config.app.indexHtml

  # redirect from root directory to UI
  router.get '/', (req, res) ->
    res.redirect '/ui'

  # check authentication for every single HTTP request
  router.all /\/(?!static)\*/, (req, res, next) ->
    if req.isAuthenticated() then next() else res.status(HttpStatus.UNAUTHORIZED).end()

  # REST handlers
  security(router, passport)
  user(router)
