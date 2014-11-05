HttpStatus = require('http-status-codes')
SecurityController = inject('controllers/security')
SecurityService = inject('services/securityService')
UserController = inject('controllers/user')
SettingsController = inject('controllers/settings')
UomController = inject('controllers/uom')
inviteService = inject('services/inviteService')
linkService = inject('services/linkService')
UserService = inject('services/userService')
i18n = inject('i18n')
settingsService = inject('services/settingsService')
UomService = inject('services/uomService')
UomStore = inject('persistence/uomStore')
CurrencyController = inject('controllers/currency')
CurrencyService = inject('services/currencyService')
CurrencyStore = inject('persistence/currencyStore')
CompanyController = inject('controllers/company')
CompanyService = inject('services/companyService')
CompanyStore = inject('persistence/companyStore')
AccountController = inject('controllers/account')
AccountService = inject('services/accountService')
AccountStore = inject('persistence/accountStore')
UserStore = inject('persistence/userStore')

class PageController

  constructor: (@router, @passport) ->

  register: ->

    userService = new UserService(new UserStore)

    accountService = new AccountService(new AccountStore, linkService, inviteService, userService, i18n)

    securityService = new SecurityService(@passport, accountService, i18n)
    securityService.applyLocalStrategy()

    securityController = new SecurityController(securityService)
    securityController.register(@router)

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

    @router.get '/i18n/messages/:batch', (req, res) =>
      res.send(i18n.bundle(req.params.batch))

    accountController = new AccountController(accountService)
    accountController.register(@router)

    userController = new UserController(userService)
    userController.register(@router)

    settingsController = new SettingsController(settingsService)
    settingsController.register(@router)

    uomController = new UomController(new UomService(new UomStore))
    uomController.register(@router)

    currencyController = new CurrencyController(new CurrencyService(new CurrencyStore))
    currencyController.register(@router)

    companyController = new CompanyController(new CompanyService(inviteService, new CompanyStore))
    companyController.register(@router)

module.exports = PageController
