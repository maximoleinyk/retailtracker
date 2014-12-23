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

  Controller.extend

    dashboard: ->
      companies = new Companies
      activities = new Activities

      Promise.all([activities.fetch(), companies.fetch()]).then =>
        @openPage new DashboardPage({
          companies: companies
          activities: activities
        })

    createCompany: ->
      currency = new Currency()
      currency.getTemplates()
      .then (currencies) =>
        @openPage new CreateCompanyPage({
          model: new Company
          currencies: currencies
        })

    editCompany: (id) ->
      currency = new Currency
      model = new Company({ _id: id }, { parse: true })

      Promise.all([model.fetch(), currency.getTemplates()])
      .then (response) =>
        @openPage new EditCompanyPage({
          model: model
          currencies: response[1]
        })

    settings: (view) ->
      @openPage new SettingsPage({
        view: view
      })
