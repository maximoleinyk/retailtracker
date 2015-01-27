define (require) ->
  'use strict'

  Layout = require('app/common/marionette/layout')
  $ = require('jquery')
  Model = require('cs!app/common/model')
  context = require('cs!app/common/context')
  request = require('app/common/request')
  select = require('select')

  Layout.extend

    template: require('hbs!./choose.hbs')
    className: 'page page-box'

    initialize: ->
      @model = new Model

    templateHelpers: ->
      hasCompanies: @options.companies.length > 0

    onRender: ->
      @model.set('companyId', @options.companies.models[0]?.id)
      @renderCompanySelect()
      @applyClassSelector()

    applyClassSelector: ->
      $('.app > .content-wrapper').addClass('box-like')

    renderCompanySelect: ->
      select @ui.$companySelect,
        data: @options.companies.map (model) ->
          id: model.id
          text: model.get('name')
        initSelection: ($el, callback) =>
          companyId = $el.val()
          callback({
            id: companyId
            text: @options.companies.get(companyId).get('name')
          })

    enter: (e) ->
      e.preventDefault()

      companyId = @model.get('companyId')
      userId = context.get('account.owner._id')

      request.post('/company/' + companyId + '/permission/' + userId)
      .then =>
        @eventBus.trigger('module:load', 'company', @model.get('companyId'))
