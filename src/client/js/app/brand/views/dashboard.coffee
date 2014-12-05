define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  CompanyList = require('cs!app/brand/views/company/list')
  ActivityList = require('cs!app/brand/views/activity/list')

  Layout.extend

    template: require('hbs!./dashboard.hbs')
    className: 'container'

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