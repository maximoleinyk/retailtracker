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
SettingsService = inject('services/settingsService')
UomService = inject('services/uomService')
UomStore = inject('persistence/uomStore')
CurrencyController = inject('controllers/currency')
CurrencyService = inject('services/currencyService')
CurrencyStore = inject('persistence/currencyStore')
CounterpartyController = inject('controllers/counterparty')
CounterpartyService = inject('services/counterpartyService')
CounterpartyStore = inject('persistence/counterpartyStore')
CompanyController = inject('controllers/company')
CompanyService = inject('services/companyService')
CompanyStore = inject('persistence/companyStore')
AccountController = inject('controllers/account')
AccountService = inject('services/accountService')
AccountStore = inject('persistence/accountStore')
UserStore = inject('persistence/userStore')
CompanyMediator = inject('services/companyMediator')
ActivityController = inject('controllers/activity')
ActivityService = inject('services/activityService')
ActivityStore = inject('persistence/activityStore')
ContextController = inject('controllers/context')
ContextService = inject('services/contextService')
NomenclatureStore = inject('persistence/nomenclatureStore')
NomenclatureService = inject('services/nomenclatureService')
NomenclatureController = inject('controllers/nomenclature')
ProductGroupController = inject('controllers/productGroup')
ProductGroupService = inject('services/productGroupService')
ProductGroupStore = inject('persistence/productGroupStore')
WarehouseController = inject('controllers/warehouse')
WarehouseService = inject('services/warehouseService')
WarehouseStore = inject('persistence/warehouseStore')
moment = require('moment')
_ = require('underscore')

class PageController

  constructor: (@router, @passport) ->

  register: ->
    currencyService = new CurrencyService(new CurrencyStore)

    counterpartyService = new CounterpartyService(new CounterpartyStore)

    companyStore = new CompanyStore

    contextService = new ContextService(currencyService, companyStore)

    activityService = new ActivityService(new ActivityStore, companyStore)

    userService = new UserService(new UserStore)

    companyMediator = new CompanyMediator(companyStore, activityService)

    accountService = new AccountService(companyMediator, new AccountStore, linkService, inviteService, userService,
      i18n, activityService)

    companyService = new CompanyService(companyStore, inviteService, accountService, userService, activityService,
      contextService, i18n)

    securityService = new SecurityService(@passport, accountService, i18n)
    securityService.applyLocalStrategy()

    securityController = new SecurityController(securityService)
    securityController.register(@router)

    # redirect from login page if user is authenticated
    @router.get '/page/account/login', (req, res, next) ->
      if req.isAuthenticated() then res.redirect('/page/brand') else next()

    # always return single HTML page on leading /page* part
    @router.get "/page*", (req, res) ->
      res.cookie('X-Csrf-Token', req.csrfToken())
      res.sendFile(global.config.app.indexHtml)

    # redirect from root directory to UI
    @router.get '/', (req, res) ->
      res.redirect '/page/account/login'

    @router.get '/i18n/messages/:batch', (req, res) =>
      res.send(i18n.bundle(req.params.batch))

    contextController = new ContextController(accountService)
    contextController.register(@router)

    warehouseController = new WarehouseController(new WarehouseService(new WarehouseStore))
    warehouseController.register(@router)

    activityController = new ActivityController(activityService)
    activityController.register(@router)

    accountController = new AccountController(accountService)
    accountController.register(@router)

    userController = new UserController(userService)
    userController.register(@router)

    settingsController = new SettingsController(new SettingsService(i18n, userService, accountService))
    settingsController.register(@router)

    uomService = new UomService(new UomStore)
    uomController = new UomController(uomService)
    uomController.register(@router)

    currencyController = new CurrencyController(currencyService)
    currencyController.register(@router)

    counterpartyController = new CounterpartyController(counterpartyService)
    counterpartyController.register(@router)

    companyController = new CompanyController(companyService)
    companyController.register(@router)

    productGroupService = new ProductGroupService(new ProductGroupStore)
    productGroupController = new ProductGroupController(productGroupService)
    productGroupController.register(@router)

    nomenclatureController = new NomenclatureController(new NomenclatureService(uomService, productGroupService,
      new NomenclatureStore))
    nomenclatureController.register(@router)

    data = []
    daySince = 30

    while (daySince)
      do ->
        date = moment().subtract(daySince, 'months')
        for sale in _.range(Math.floor(Math.random() * (20 - 1) + 1))
          do ->
            amount = Math.floor(Math.random() * (1000 - 55.5) + 55.5)
            data.push({ date: date, amount: amount })
        daySince--

    @router.get '/generate/data', (req, res) ->
      res.status(HttpStatus.OK).send(data)

module.exports = PageController
