define (require) ->
  'use strict'

  Promise = require('rsvp').Promise
  Controller = require('cs!app/common/controller');
  SettingsPage = require('cs!app/brand/views/settings/main')
  DashboardPage = require('cs!./views/dashboard')
  Uom = require('cs!./collections/uoms')
  UomPage = require('cs!./views/uom')
  Currencies = require('cs!./collections/currencies')
  CurrenciesPage = require('cs!./views/currencies')
  Counterparties = require('cs!./collections/counterparties')
  CounterpartiesPage = require('cs!./views/counterparty/list')
  CounterpartyFormPage = require('cs!./views/counterparty/form')
  NomenclatureListPage = require('cs!./views/nomenclature/list')
  NomenclatureCollection = require('cs!./collections/nomenclature')
  Nomenclature = require('cs!./models/nomenclature')
  NomenclatureFormPage = require('cs!./views/nomenclature/form')
  ProductGroups = require('cs!./collections/productGroups')
  ProductGroupsPage = require('cs!./views/productGroups')
  Warehouses = require('cs!./collections/warehouses')
  WarehousesPage = require('cs!./views/warehouse/list')
  Currency = require('cs!./models/currency')
  Counterparty = require('cs!./models/counterparty')
  ChoosePosPage = require('cs!./views/pos/choose')
  Employees = require('cs!app/company/collections/employees')
  ManageCompanyEmployeesPage = require('cs!app/company/views/employees/list')
  context = require('cs!app/common/context')
  Stores = require('cs!app/company/collections/stores')
  StoresPage = require('cs!./views/store/list')
  Store = require('cs!./models/store')
  StoreFormPage = require('cs!./views/store/form')
  WarehouseFormPage = require('cs!./views/warehouse/form')
  Warehouse = require('cs!./models/warehouse')
  SupplierOrdersPage = require('cs!./views/supplierOrders/list')
  SupplierOrders = require('cs!./collections/supplierOrders')
  Formulas = require('cs!./collections/formulas')
  FormulasPage = require('cs!./views/formula/list')
  FormulaForm = require('cs!./views/formula/form')
  Formula = require('cs!./models/formula')
  PriceListsPage = require('cs!./views/priceLists/list')
  PriceLists = require('cs!./collections/priceLists')
  PriceList = require('cs!./models/priceList')
  PriceListForm = require('cs!./views/priceLists/form')
  ReceiveGoodsCollection = require('cs!./collections/receiveGoods')
  ReceiveGoodsList = require('cs!./views/receiveGoods/list')
  PriceListItems = require('cs!app/company/collections/priceListItems')
  PosList = require('cs!app/company/views/pos/list')
  PosCollection = require('cs!app/company/collections/pos')
  PosModel = require('cs!app/company/models/pos')
  PosForm = require('cs!app/company/views/pos/form')

  Controller.extend

    posList: ->
      collection = new PosCollection
      collection.fetch().then =>
        @openPage new PosList
          collection: collection

    posForm: (id) ->
      model = if id and id isnt 'create' then new PosModel({ _id: id }, { parse: true }) else new PosModel
      showPage = =>
        @openPage new PosForm({
          model: model
        })
      if model.isNew() then showPage() else model.fetch().then(showPage)

    receiveGoods: ->
      collection = new ReceiveGoodsCollection
      collection.fetch().then =>
        @openPage new ReceiveGoodsList({
          collection: collection
        })

    priceListForm: (id) ->
      model = if id and id isnt 'create' then new PriceList({ _id: id }, { parse: true }) else new PriceList
      priceListItems = new PriceListItems

      showPage = =>
        @openPage new PriceListForm({
          model: model
          priceListItems: priceListItems
        })

      if model.isNew() then showPage() else Promise.all([model.fetch(),
                                                         priceListItems.fetchByPriceList(id)]).then(showPage)

    priceLists: ->
      collection = new PriceLists
      collection.fetch().then =>
        @openPage new PriceListsPage({
          collection: collection
        })

    formulaForm: (id) ->
      model = if id and id isnt 'create' then new Formula({ _id: id }, { parse: true }) else null

      openPage = =>
        @openPage new FormulaForm({
          model: if model then model else new Formula
        })

      if model
        model.fetch().then(openPage)
      else
        openPage()

    formulas: ->
      collection = new Formulas
      collection.fetch().then =>
        @openPage new FormulasPage({
          collection: collection
        })

    ordersToSuppliers: ->
      collection = new SupplierOrders
      collection.fetch().then =>
        @openPage new SupplierOrdersPage({
          collection: collection
        })

    storeForm: (id) ->
      model = if id and id isnt 'create' then new Store({ _id: id }, { parse: true }) else null

      openPage = =>
        @openPage new StoreFormPage({
          model: if model then model else new Store
        })

      if model
        model.fetch().then(openPage)
      else
        openPage()

    stores: ->
      stores = new Stores
      stores.fetch().then =>
        @openPage new StoresPage({
          collection: stores
        })

    employeeList: ->
      employees = new Employees()

      Promise.all([employees.fetch(context.get('company._id'))])
      .then =>
        @openPage new ManageCompanyEmployeesPage({
          url: '/page/company/' + context.get('company._id')
          collection: employees
        })

    employeeForm: (id) ->
      # todo: implement

    choose: ->
      stores = new Stores
      stores.fetch().then =>
        @openPage new ChoosePosPage
          stores: stores

    warehouseList: ->
      collection = new Warehouses
      collection.fetch()
      .then =>
        @openPage new WarehousesPage({
          collection: collection
        })

    warehouseForm: (id) ->
      model = if id and id isnt 'create' then new Warehouse({ _id: id }, { parse: true }) else null

      openPage = =>
        @openPage new WarehouseFormPage({
          model: if model then model else new Warehouse
        })

      if model
        model.fetch().then(openPage)
      else
        openPage()

    nomenclatureForm: (id) ->
      model = if id and id isnt 'create' then new Nomenclature({ _id: id }, { parse: true }) else null

      openPage = =>
        @openPage new NomenclatureFormPage({
          model: if model then model else new Nomenclature
        })

      if model
        model.fetch().then(openPage)
      else
        openPage()

    copyNomenclature: (copyId) ->
      model = new Nomenclature({ id: copyId })
      model.fetch()
      .then =>
        delete model.attributes.id
        @openPage new NomenclatureFormPage({
          model: model.clone()
        })

    nomenclatureList: ->
      collection = new NomenclatureCollection()
      collection.fetch()
      .then =>
        @openPage new NomenclatureListPage({
          collection: collection
        })

    dashboard: ->
      @openPage(new DashboardPage)

    productGroups: ->
      collection = new ProductGroups
      collection.fetch()
      .then =>
        @openPage new ProductGroupsPage({
          collection: collection
        })

    uom: ->
      collection = new Uom
      collection.fetch()
      .then =>
        @openPage new UomPage({
          collection: collection
        })

    currency: ->
      currency = new Currency
      collection = new Currencies
      Promise.all([collection.fetch(), currency.getTemplates()])
      .then (response) =>
        @openPage new CurrenciesPage({
          collection: collection
          currencies: response[1]
        })

    counterpartyList: ->
      collection = new Counterparties
      collection.fetch()
      .then =>
        @openPage new CounterpartiesPage({
          collection: collection
        })

    counterpartyForm: (id) ->
      model = if id and id isnt 'create' then new Counterparty({ _id: id }, { parse: true }) else null

      openPage = =>
        @openPage new CounterpartyFormPage({
          model: if model then model else new Counterparty
        })

      if model
        model.fetch().then(openPage)
      else
        openPage()

    settings: (view) ->
      @openPage new SettingsPage({
        view: view
      })
