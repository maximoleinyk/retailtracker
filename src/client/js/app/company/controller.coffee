define (require) ->
  'use strict'

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
  CreateNomenclaturePage = require('cs!./views/nomenclature/create')
  Nomenclature = require('cs!./models/nomenclature')
  NomenclatureFormPage = require('cs!./views/nomenclature/form')
  ProductGroups = require('cs!./collections/productGroups')
  ProductGroupsPage = require('cs!./views/productGroups/list')
  Warehouses = require('cs!./collections/warehouses')
  WarehousesPage = require('cs!./views/warehouse/list')
  Promise = require('rsvp').Promise
  Currency = require('cs!./models/currency')
  Counterparty = require('cs!./models/counterparty')
  ChoosePosPage = require('cs!./views/pos/choose')

  Controller.extend

    choose: ->
      @openPage new ChoosePosPage

    warehouses: ->
      collection = new Warehouses
      collection.fetch()
      .then =>
        @openPage new WarehousesPage({
          collection: collection
        })

    nomenclatureForm: (id) ->
      model = if id isnt 'create' then new Nomenclature({ _id: id }, { parse: true }) else null

      openPage = =>
        @openPage new NomenclatureFormPage({
          model: model
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
        @openPage new CreateNomenclaturePage({
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

    listCounterparties: ->
      collection = new Counterparties
      collection.fetch()
      .then =>
        @openPage new CounterpartiesPage({
          collection: collection
        })

    counterpartyForm: (id) ->
      model = if id isnt 'create' then new Counterparty({ _id: id }, { parse: true }) else null

      openPage = =>
        @openPage new CounterpartyFormPage({
          model: model
        })

      if model
        model.fetch().then(openPage)
      else
        openPage()

    settings: (view) ->
      @openPage new SettingsPage({
        view: view
      })
