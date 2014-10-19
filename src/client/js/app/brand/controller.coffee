define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller')
  HomePage = require('cs!./views/home')
  SettingsPage = require('cs!./views/settings/main')
  CreateCompanyPage = require('cs!./views/company/create')
  EditCompanyPage = require('cs!./views/company/edit')
  ViewCompanyPage = require('cs!./views/company/view')
  Company = require('cs!./models/company')
  Companies = require('cs!./collections/companies')

  Controller.extend

    home: ->
      companies = new Companies
      companies.fetch().then =>
        @openPage new HomePage({
          companies: companies
        })

    createCompany: ->
      @openPage new CreateCompanyPage({
        model: new Company
      })

    editCompany: (id) ->
      model = new Company({ id: id }, { parse: true })
      model.fetch().then =>
        @openPage new EditCompanyPage({
          model: model
        })

    viewCompany: (id) ->
      model = new Company({ id: id }, { parse: true })
      model.fetch().then =>
        @openPage new ViewCompanyPage({
          model: model
        })

    settings: (view) ->
      @openPage new SettingsPage({
        view: view
      })
