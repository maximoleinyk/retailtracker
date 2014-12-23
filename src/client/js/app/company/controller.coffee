define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  SettingsPage = require('cs!app/brand/views/settings/main')
  DashboardPage = require('cs!./views/dashboard')
  Uom = require('cs!./collections/uoms')
  UomPage = require('cs!./views/uom')
  Currencies = require('cs!./collections/currencies')
  CurrenciesPage = require('cs!./views/currencies')
  NomenclatureListPage = require('cs!./views/nomenclature/list')
  NomenclatureCollection = require('cs!./collections/nomenclature')
  CreateNomenclaturePage = require('cs!./views/nomenclature/create')
  Nomenclature = require('cs!./models/nomenclature')
  ViewNomenclaturePage = require('cs!./views/nomenclature/view')
  EditNomenclaturePage = require('cs!./views/nomenclature/edit')
  ProductGroups = require('cs!./collections/productGroups')
  ProductGroupsPage = require('cs!./views/productGroups/list')
  Warehouses = require('cs!./collections/warehouses')
  WarehousesPage = require('cs!./views/warehouse/list')
  Promise = require('rsvp').Promise
  Currency = require('cs!./models/currency')

  Controller.extend

    warehouses: ->
      collection = new Warehouses
      collection.fetch()
      .then =>
        @openPage new WarehousesPage({
          collection: collection
        })

    editNomenclature: (id) ->
      model = new Nomenclature({ id: id })
      model.fetch()
      .then =>
        @openPage new EditNomenclaturePage({
          model: model
        })

    viewNomenclature: (id) ->
      model = new Nomenclature({ id: id })
      model.fetch()
      .then =>
        @openPage new ViewNomenclaturePage({
          model: model
        })

    createNomenclature: ->
      @openPage new CreateNomenclaturePage({
        model: new Nomenclature
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

    settings: (view) ->
      @openPage new SettingsPage({
        view: view
      })