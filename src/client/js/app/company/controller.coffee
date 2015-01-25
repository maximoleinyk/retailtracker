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
  ProductGroupsPage = require('cs!./views/productGroups/list')
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
  PriceListTemplates = require('cs!./collections/priceListTemplates')
  PriceListTemplatesPage = require('cs!./views/templates/list')
  PriceListTemplateForm = require('cs!./views/templates/form')
  PriceListTemplate = require('cs!./models/priceListTemplate')
  PriceListsPage = require('cs!./views/priceLists/list')
  PriceLists = require('cs!./collections/priceLists')
  PriceList = require('cs!./models/priceList')
  PriceListForm = require('cs!./views/priceLists/form')

  Controller.extend

    priceListForm: (id) ->
      model = if id and id isnt 'create' then new PriceList({ _id: id }, { parse: true }) else null

      openPage = =>
        @openPage new PriceListForm({
          model: if model then model else new PriceList
        })

      if model
        model.fetch().then(openPage)
      else
        openPage()

    priceLists: ->
      collection = new PriceLists
      collection.fetch().then =>
        @openPage new PriceListsPage({
          collection: collection
        })

    priceListTemplatesForm: (id) ->
      model = if id and id isnt 'create' then new PriceListTemplate({ _id: id }, { parse: true }) else null

      openPage = =>
        @openPage new PriceListTemplateForm({
          model: if model then model else new PriceListTemplate
        })

      if model
        model.fetch().then(openPage)
      else
        openPage()

    priceListTemplates: ->
      collection = new PriceListTemplates
      collection.fetch().then =>
        @openPage new PriceListTemplatesPage({
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
      @openPage new ChoosePosPage

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
