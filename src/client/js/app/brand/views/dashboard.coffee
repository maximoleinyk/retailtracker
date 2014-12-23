define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  CompanyList = require('cs!app/brand/views/company/list')
  ActivityList = require('cs!app/brand/views/activity/list')

  Layout.extend

    template: require('hbs!./dashboard.hbs')
    className: 'page page-halves'

    createCompany: ->
      @navigateTo('company/create')

    onRender: ->
      @renderCompanies()
      @renderActivities()

    renderCompanies: ->
      @companies.show new CompanyList({
        collection: @options.companies
      })

    renderActivities: ->
      @activities.show new ActivityList({
        collection: @options.activities
      })