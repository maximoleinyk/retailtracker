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

  Controller.extend

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

    uom: ->
      collection = new Uom
      collection.fetch()
      .then =>
        @openPage new UomPage({
          collection: collection
        })

    currency: ->
      collection = new Currencies
      collection.fetch()
      .then =>
        @openPage new CurrenciesPage({
          collection: collection
        })

    settings: (view) ->
      @openPage new SettingsPage({
        view: view
      })