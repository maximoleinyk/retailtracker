define (require) ->
  'use strict'

  Layout = require('app/common/marionette/layout')
  $ = require('jquery')
  Company = require('cs!app/brand/models/company')
  context = require('cs!app/common/context')
  request = require('app/common/request')
  http = require('app/common/http')

  Layout.extend

    template: require('hbs!./choose.hbs')
    className: 'page page-box'

    initialize: ->
      @model = new Company

    templateHelpers: ->
      hasCompanies: @options.companies.length > 0

    onRender: ->
      @model.set('companyId', @options.companies.models[0]?.id)
      @renderCompanySelect()
      @applyClassSelector()

    applyClassSelector: ->
      $('.app > .content-wrapper').addClass('box-like')

    renderCompanySelect: ->
      @ui.$companySelect.selectBox
        data: @options.companies.map (model) ->
          id: model.id
          text: model.get('name')
        initSelection: ($el, callback) =>
          companyId = $el.val()
          callback({
            id: companyId
            text: @options.companies.get(companyId).get('name')
          })

    enter: ->
      companyId = @model.get('companyId')
      @model.set('id', companyId)

      companyAndAccount = _.find context.get('account.companies'), (pair) ->
        pair.company is companyId

      http.setHeaders {
        account: companyAndAccount.account
      }

      @model.startSession().then =>
        @eventBus.trigger('module:load', 'company', companyId)
