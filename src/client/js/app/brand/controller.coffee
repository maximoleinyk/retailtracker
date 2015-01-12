define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller')
  DashboardPage = require('cs!./views/dashboard')
  SettingsPage = require('cs!./views/settings/main')
  CreateCompanyPage = require('cs!./views/company/create')
  EditCompanyPage = require('cs!./views/company/edit')
  Company = require('cs!./models/company')
  Companies = require('cs!./collections/companies')
  Activities = require('cs!./collections/activities')
  Promise = require('rsvp').Promise
  Currency = require('cs!app/company/models/currency')
  CompanyListPage = require('cs!./views/company/list')
  ManageCompanyEmployeesPage = require('cs!./views/company/employees')
  Collection = require('cs!app/common/collection')
  Roles = require('cs!app/brand/collections/roles')

  Controller.extend

    chooseCompany: ->
      # todo implement

    choosePos: ->
      # todo implement

    dashboard: ->
      companies = new Companies
      activities = new Activities

      Promise.all([activities.fetch(), companies.fetch()]).then =>
        @openPage new DashboardPage({
          companies: companies
          activities: activities
        })

    manageCompanyEmployees: (companyId) ->
      model = new Company({ _id: companyId }, { parse: true })
      model.fetch()
      .then () =>
        @openPage new ManageCompanyEmployeesPage({
          collection: new Collection model.get('employees')
          model: model
        })

    companies: ->
      companies = new Companies
      companies.fetch().then =>
        @openPage new CompanyListPage({
          collection: companies
        })

    createCompany: ->
      roles = new Roles()
      currency = new Currency()

      Promise.all([currency.getTemplates(), roles.fetch()])
      .then (response) =>
        @openPage new CreateCompanyPage({
          model: new Company
          currencies: response[0]
          roles: roles
        })

    editCompany: (id) ->
      roles = new Roles()
      currency = new Currency
      model = new Company({ _id: id }, { parse: true })

      Promise.all([currency.getTemplates(), roles.fetch(), model.fetch()])
      .then (response) =>
        @openPage new EditCompanyPage({
          model: model
          currencies: response[0]
          roles: roles
        })

    settings: (view) ->
      @openPage new SettingsPage({
        view: view
      })
