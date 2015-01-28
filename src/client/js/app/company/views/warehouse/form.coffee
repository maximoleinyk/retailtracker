define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  i18n = require('cs!app/common/i18n')
  select = require('select')
  context = require('cs!app/common/context')
  _ = require('underscore')

  ItemView.extend

    template: require('hbs!./form.hbs')
    className: 'page page-2thirds'

    templateHelpers: ->
      isNew: @model.isNew()

    onRender: ->
      @renderAssigneeSelect()

    assigneeFormatter: (obj) =>
      if obj.text then obj.text else obj.firstName + ' ' + obj.lastName + ' ' + obj.email

    renderAssigneeSelect: ->
      select(@ui.$assigneeSelect, {
        id: (employee) ->
          return employee._id
        ajax:
          url: '/employees/select/fetch'
          dataType: 'jsonp'
          quietMillis: 150,
          data: (term) ->
            q: term
          results: (data) ->
            results: data
        formatSelection: @assigneeFormatter
        formatResult: @assigneeFormatter
        initSelection: (element, callback) =>
          callback(@model.get('assignee'))
      })

    submit: (e) ->
      e.preventDefault()

      assignee = @model.get('assignee')
      @model.set('assignee', if _.isObject(assignee) then assignee._id else assignee)
      @model.save().then =>
        @navigateTo('/warehouses')
