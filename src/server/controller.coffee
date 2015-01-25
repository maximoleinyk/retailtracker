_ = require('underscore')
moment = require('moment')
i18n = inject('util/i18n')
HttpStatus = require('http-status-codes')
SecurityController = inject('controllers/security')
SecurityService = inject('services/securityService')
UserController = inject('controllers/user')
SettingsController = inject('controllers/settings')
UomController = inject('controllers/uom')
LinkStore = inject('persistence/linkStore')
LinkService = inject('services/linkService')
InviteStore = inject('persistence/inviteStore')
InviteService = inject('services/inviteService')
UserService = inject('services/userService')
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
RoleService = inject('services/roleService')
RoleStore = inject('persistence/roleStore')
RoleController = inject('controllers/role')
EmployeeService = inject('services/employeeService')
EmployeeStore = inject('persistence/employeeStore')
EmployeeController = inject('controllers/employee')
namespace = inject('util/namespace')
warehouseSchema = inject('persistence/model/warehouse')
counterpartySchema = inject('persistence/model/counterparty')
StoreService = inject('services/storeService')
StoreController = inject('controllers/store')
StoreDataStore = inject('persistence/storeDataStore')
storeSchema = inject('persistence/model/store')
SupplierOrdersController = inject('controllers/supplierOrders')
PriceListTemplateController = inject('controllers/priceListTemplate')
PriceListTemplateStore = inject('persistence/priceListTemplateStore')
PriceListTemplateService = inject('services/priceListTemplateService')
priceListTemplateSchema = inject('persistence/model/priceListTemplate')
currencySchema = inject('persistence/model/currency')

class PageController

  constructor: (@router, @passport) ->

  register: ->
    priceListTemplateStore = new PriceListTemplateStore(priceListTemplateSchema)
    priceListTemplateService = new PriceListTemplateService(priceListTemplateStore)
    priceListTemplateController = new PriceListTemplateController(priceListTemplateService, namespace.company)
    priceListTemplateController.register(@router)

    supplierOrdersController = new SupplierOrdersController
    supplierOrdersController.register(@router)

    storeController = new StoreController(new StoreService(new StoreDataStore(storeSchema)), namespace.company)
    storeController.register(@router)

    currencyService = new CurrencyService(new CurrencyStore(currencySchema))

    counterpartyService = new CounterpartyService(new CounterpartyStore(counterpartySchema))

    roleService = new RoleService(new RoleStore)

    companyStore = new CompanyStore

    contextService = new ContextService(currencyService, companyStore, roleService)

    activityService = new ActivityService(new ActivityStore, companyStore)

    userService = new UserService(new UserStore)

    linkService = new LinkService(new LinkStore)

    inviteStore = new InviteStore()
    inviteService = new InviteService(inviteStore)

    employeeService = new EmployeeService(companyStore, roleService, new EmployeeStore)

    accountService = new AccountService(employeeService, contextService, companyStore, new AccountStore, linkService,
      inviteService, userService, activityService)

    companyService = new CompanyService(employeeService, roleService, companyStore, inviteService, accountService,
      userService, activityService,
      contextService)

    securityService = new SecurityService(@passport, accountService)
    securityService.applyLocalStrategy()

    securityController = new SecurityController(securityService)
    securityController.register(@router)

    contextController = new ContextController(accountService)
    contextController.register(@router)

    warehouseController = new WarehouseController(new WarehouseService(new WarehouseStore(warehouseSchema)),
      namespace.company)
    warehouseController.register(@router)

    activityController = new ActivityController(activityService)
    activityController.register(@router)

    accountController = new AccountController(accountService)
    accountController.register(@router)

    userController = new UserController(userService)
    userController.register(@router)

    settingsController = new SettingsController(new SettingsService(userService, accountService))
    settingsController.register(@router)

    uomService = new UomService(new UomStore)
    uomController = new UomController(uomService)
    uomController.register(@router)

    currencyController = new CurrencyController(currencyService, namespace.company)
    currencyController.register(@router)

    counterpartyController = new CounterpartyController(counterpartyService, namespace.company)
    counterpartyController.register(@router)

    companyController = new CompanyController(companyService)
    companyController.register(@router)

    productGroupService = new ProductGroupService(new ProductGroupStore)
    productGroupController = new ProductGroupController(productGroupService)
    productGroupController.register(@router)

    nomenclatureController = new NomenclatureController(new NomenclatureService(uomService, productGroupService,
      new NomenclatureStore))
    nomenclatureController.register(@router)

    roleController = new RoleController(roleService)
    roleController.register(@router)

    employeeController = new EmployeeController(employeeService)
    employeeController.register(@router)

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

module.exports = PageController
