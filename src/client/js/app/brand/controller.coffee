define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller')
  DashboardPage = require('cs!./views/dashboard')
  SettingsPage = require('cs!./views/settings/main')
  CreateCompanyPage = require('cs!./views/company/create')
  EditCompanyPage = require('cs!./views/company/edit')
  Company = require('cs!./models/company')
  Companies = require('cs!./collections/companies')

  Controller.extend

    dashboard: ->
      companies = new Companies
      Promise.all([companies.fetch()]).then =>
        @openPage new DashboardPage({
          companies: companies
        })

    createCompany: ->
      @openPage new CreateCompanyPage({
        model: new Company
      })

    editCompany: (id) ->
      model = new Company({ _id: id }, { parse: true })
      model.fetch().then =>
        @openPage new EditCompanyPage({
          model: model
        })

    settings: (view) ->
      @openPage new SettingsPage({
        view: view
      })
