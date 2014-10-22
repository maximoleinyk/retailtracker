define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  CompanyList = require('cs!app/brand/views/company/list')

  Layout.extend

    template: require('hbs!./dashboard')
    className: 'container'

    createCompany: ->
      @navigate('company/create')

    onRender: ->
      @renderCompanies()
      @renderActivities()

    renderCompanies: ->
      @companies.show new CompanyList({
        collection: @options.companies
      })

    renderActivities: ->
      # TODO:implement