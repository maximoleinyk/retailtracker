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
warehouseSchema = inject('persistence/model/warehouse')
counterpartySchema = inject('persistence/model/counterparty')
StoreService = inject('services/storeService')
StoreController = inject('controllers/store')
StoreDataStore = inject('persistence/storeDataStore')
storeSchema = inject('persistence/model/store')
SupplierOrdersController = inject('controllers/supplierOrders')
FormulaController = inject('controllers/formula')
FormulaStore = inject('persistence/formulaStore')
FormulaService = inject('services/formulaService')
formulaSchema = inject('persistence/model/formula')
currencySchema = inject('persistence/model/currency')
PriceListController = inject('controllers/priceList')
PriceListStore = inject('persistence/priceListStore')
PriceListService = inject('services/priceListService')
priceListSchema = inject('persistence/model/priceList')
receiveGoodSchema = inject('persistence/model/receiveGoods')
ReceiveGoodsStore = inject('persistence/receiveGoodsStore')
ReceiveGoodsService = inject('services/receiveGoodsService')
ReceiveGoodsController = inject('controllers/receiveGoods')
nomenclatureSchema = inject('persistence/model/nomenclature')
uomSchema = inject('persistence/model/uom')
productGroupSchema = inject('persistence/model/productGroup')
PriceListItemController = inject('controllers/priceListItem')
PriceListItemService = inject('services/priceListItemService')
PriceListItemStore = inject('persistence/priceListItemStore')
priceListItemSchema = inject('persistence/model/priceListItem')
posSchema = inject('persistence/model/pos')
PosStore = inject('persistence/posStore')
PosService = inject('services/posService')
PosController = inject('controllers/pos')
employeeSchema = inject('persistence/model/employee')
pageController = inject('controllers/page')
express = require('express')
WarehouseItemService = inject('services/warehouseItemService')
WarehouseItemStore = inject('persistence/warehouseItemStore')
WarehouseItemService = inject('services/warehouseItemService')
warehouseItemSchema = inject('persistence/model/warehouseItem')

module.exports = (app, passport) ->
  router = express.Router()

  app.use pageController()

  posStore = new PosStore(posSchema)
  posService = new PosService(posStore)
  posController = new PosController(posService)
  posController.register(router)

  currencyStore = new CurrencyStore(currencySchema)
  currencyService = new CurrencyService(currencyStore)
  currencyController = new CurrencyController(currencyService)
  currencyController.register(router)

  nomenclatureStore = new NomenclatureStore(nomenclatureSchema)
  nomenclatureService = new NomenclatureService(nomenclatureStore)
  nomenclatureController = new NomenclatureController(nomenclatureService)
  nomenclatureController.register(router)

  warehouseItemStore = new WarehouseItemStore(warehouseItemSchema)
  warehouseItemService = new WarehouseItemService(warehouseItemStore)

  receiveGoodsStore = new ReceiveGoodsStore(receiveGoodSchema)
  receiveGoodsService = new ReceiveGoodsService(receiveGoodsStore, warehouseItemService, currencyStore, nomenclatureStore)
  receiveGoodsController = new ReceiveGoodsController(receiveGoodsService)
  receiveGoodsController.register(router)

  priceListStore = new PriceListStore(priceListSchema)
  priceListService = new PriceListService(priceListStore)
  priceListController = new PriceListController(priceListService)
  priceListController.register(router)

  formulaStore = new FormulaStore(formulaSchema)
  formulaService = new FormulaService(formulaStore)
  formulaController = new FormulaController(formulaService)
  formulaController.register(router)

  priceListItemStore = new PriceListItemStore(priceListItemSchema)
  priceListItemService = new PriceListItemService(priceListItemStore, formulaStore)
  priceListItemController = new PriceListItemController(priceListItemService)
  priceListItemController.register(router)

  supplierOrdersController = new SupplierOrdersController
  supplierOrdersController.register(router)

  storeController = new StoreController(new StoreService(new StoreDataStore(storeSchema)))
  storeController.register(router)

  roleStore = new RoleStore
  roleService = new RoleService(roleStore)

  companyStore = new CompanyStore

  contextService = new ContextService(currencyService, companyStore, roleService)

  activityService = new ActivityService(new ActivityStore, companyStore)

  userService = new UserService(new UserStore)

  linkService = new LinkService(new LinkStore)

  inviteStore = new InviteStore()
  inviteService = new InviteService(inviteStore)

  employeeStore = new EmployeeStore(employeeSchema)
  employeeService = new EmployeeService(employeeStore, companyStore, roleStore)
  employeeController = new EmployeeController(employeeService)
  employeeController.register(router)

  accountService = new AccountService(employeeService, contextService, companyStore, new AccountStore, linkService,
    inviteService, userService, activityService)

  companyService = new CompanyService(employeeService, roleService, companyStore, inviteService, accountService,
    userService, activityService,
    contextService)

  securityService = new SecurityService(passport, accountService)
  securityService.applyLocalStrategy()

  securityController = new SecurityController(securityService)
  securityController.register(router)

  contextController = new ContextController(accountService, employeeService, companyService, posService, roleService)
  contextController.register(router)

  warehouseStore = new WarehouseStore(warehouseSchema)
  warehouseService = new WarehouseService(warehouseStore)
  warehouseController = new WarehouseController(warehouseService)
  warehouseController.register(router)

  activityController = new ActivityController(activityService)
  activityController.register(router)

  accountController = new AccountController(accountService)
  accountController.register(router)

  userController = new UserController(userService)
  userController.register(router)

  settingsController = new SettingsController(new SettingsService(userService, accountService))
  settingsController.register(router)

  uomStore = new UomStore(uomSchema)
  uomService = new UomService(uomStore)
  uomController = new UomController(uomService)
  uomController.register(router)

  counterpartyService = new CounterpartyService(new CounterpartyStore(counterpartySchema))
  counterpartyController = new CounterpartyController(counterpartyService)
  counterpartyController.register(router)

  companyController = new CompanyController(companyService)
  companyController.register(router)

  productGroupStore = new ProductGroupStore(productGroupSchema)
  productGroupService = new ProductGroupService(productGroupStore)
  productGroupController = new ProductGroupController(productGroupService)
  productGroupController.register(router)

  roleController = new RoleController(roleService)
  roleController.register(router)

  return router
