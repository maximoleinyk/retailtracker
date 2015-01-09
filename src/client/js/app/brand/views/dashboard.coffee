define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  CompanyTabs = require('cs!app/brand/views/company/tabs')
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
      @companies.show new CompanyTabs({
        collection: @options.companies
        tab: 'all'
      })

    renderActivities: ->
      @activities.show new ActivityList({
        collection: @options.activities
      })
