HttpStatus = require('http-status-codes')
SecurityController = inject('controllers/security')
UserController = inject('controllers/user')
SettingsController = inject('controllers/settings')
ResourceController = inject('controllers/i18n')
test = inject('controllers/test')
authFilter = inject('util/authFilter')
inviteService = inject('services/inviteService')
linkService = inject('services/linkService')
userService = inject('services/userService')
i18nService = inject('services/i18nService')
settingsService = inject('services/settingsService')

class PageController

  constructor: (@router, @passport) ->

  register: ->

    # redirect from login page if user is authenticated
    @router.get '/page/account/login', (req, res, next) ->
      if req.isAuthenticated() then res.redirect('/page') else next()

    # always return single HTML page on leading /page* part
    @router.get "/page*", (req, res) ->
      res.sendFile global.config.app.indexHtml

    # redirect from root directory to UI
    @router.get '/', (req, res) ->
      res.redirect '/page'

    @router.get '/404', (req, res) ->
      res.status(HttpStatus.NOT_FOUND).end()

    securityController = new SecurityController(inviteService, linkService, userService)
    securityController.register(@router, authFilter, @passport)

    userController = new UserController()
    userController.register(@router, authFilter)

    settingsController = new SettingsController(settingsService)
    settingsController.register(@router, authFilter)

    i18nController = new ResourceController(i18nService)
    i18nController.register(@router)

    test(@router)

module.exports = PageController
