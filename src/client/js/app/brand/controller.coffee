define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller')
  DashboardPage = require('cs!./views/dashboard')
  SettingsPage = require('cs!./views/settings/main')
  CompanyFormPage = require('cs!./views/company/form')
  Company = require('cs!./models/company')
  Companies = require('cs!./collections/companies')
  Activities = require('cs!./collections/activities')
  Promise = require('rsvp').Promise
  Currency = require('cs!app/company/models/currency')
  CompanyListPage = require('cs!./views/company/list')
  ManageCompanyEmployeesPage = require('cs!app/company/views/employees/list')
  Roles = require('cs!./collections/roles')
  Employees = require('cs!app/company/collections/employees')
  ChooseCompanyPage = require('cs!./views/company/choose')
  RoleListPage = require('cs!./views/roles/list')

  Controller.extend

    roles: ->
      roles = new Roles
      roles.fetchAll().then =>
        @openPage new RoleListPage({
          roles: roles
        })

    chooseCompany: ->
      companies = new Companies
      companies.fetch().then =>
        @openPage new ChooseCompanyPage({
          companies: companies
        })

    dashboard: ->
      companies = new Companies
      activities = new Activities

      Promise.all([activities.fetch(), companies.fetch()]).then =>
        @openPage new DashboardPage({
          companies: companies
          activities: activities
        })

    manageCompanyEmployees: (companyId) ->
      employees = new Employees()
      model = new Company({ _id: companyId }, { parse: true })
      Promise.all([model.fetch(), employees.fetch(companyId)])
      .then =>
        @openPage new ManageCompanyEmployeesPage({
          collection: employees
          model: model
        })

    companies: ->
      companies = new Companies
      companies.fetch().then =>
        @openPage new CompanyListPage({
          collection: companies
        })

    companyForm: (id) ->
      roles = new Roles()
      currency = new Currency
      model = if id isnt 'create' then new Company({ _id: id }, { parse: true }) else null
      promises = [currency.getTemplates(), roles.fetch()]
      promises.push(model.fetch()) if model

      Promise.all(promises).then (response) =>
        @openPage new CompanyFormPage({
          model: if model then model else new Company
          currencies: response[0]
          roles: roles
        })

    settings: (view) ->
      @openPage new SettingsPage({
        view: view
      })
