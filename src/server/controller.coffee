HttpStatus = require('http-status-codes')
SecurityController = inject('controllers/security')
UserController = inject('controllers/user')
SettingsController = inject('controllers/settings')
ResourceController = inject('controllers/i18n')
UomController = inject('controllers/uom')
test = inject('controllers/test')
inviteService = inject('services/inviteService')
linkService = inject('services/linkService')
userService = inject('services/userService')
i18nService = inject('services/i18nService')
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
Authentication = inject('authentication')

class PageController

  constructor: (@router, @passport) ->

  register: ->

    accountService = new AccountService(new AccountStore, linkService, inviteService, userService, i18nService)

    authenticator = new Authentication(accountService)
    authenticator.applyLocalStrategy(@passport)

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


    accountController = new AccountController(accountService)
    accountController.register(@router)

    securityController = new SecurityController(inviteService, linkService, userService)
    securityController.register(@router, @passport)

    userController = new UserController()
    userController.register(@router)

    settingsController = new SettingsController(settingsService)
    settingsController.register(@router)

    i18nController = new ResourceController(i18nService)
    i18nController.register(@router)

    uomController = new UomController(new UomService(new UomStore))
    uomController.register(@router)

    currencyController = new CurrencyController(new CurrencyService(new CurrencyStore))
    currencyController.register(@router)

    companyController = new CompanyController(new CompanyService(inviteService, new CompanyStore))
    companyController.register(@router)

    test(@router)

module.exports = PageController
