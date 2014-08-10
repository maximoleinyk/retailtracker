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

  # REST handlers
  security(router, passport)
  user(router)
